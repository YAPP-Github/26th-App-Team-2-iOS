//
//  AppGroupMainViewModel.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/28/25.
//

import Foundation
import Domain
import Core

extension AppGroup: @retroactive Identifiable, @retroactive Equatable {
    public var id: String {
        "\(self.groupID)" + self.name + self.selection.applications.map(\.hashValue).map(String.init).joined()
    }
    public static func == (lhs: AppGroup, rhs: AppGroup) -> Bool {
        lhs.id == rhs.id
    }
}

@Observable
public final class AppGroupMainViewModel {
    var brakeStatus: BrakeStatus {
        get { BrakeStatus(rawValue:  UserDefaults.standard.integer(forKey: "brakeStatus")) ?? .none }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "brakeStatus") }
    }
    
    private let scheduleKey: String = "BlockScheduleCurrent"
    private var currentSchedule: BlockSchedule?
    
    var currentActiveAppGroup: AppGroup? = nil
    var sessionExitAlertPresent: Bool = false
    var timerSettingPresent: Bool = false
    var sessionRestRatio: Double = 0.0
    var sessionRestTime: Int = 0
    
    var editAppGroup: AppGroup? = nil
    var addGroupPresent: Bool = false
    
    var screenTimeAuthAlertPresent: Bool = false
    var screenTimeAuthErrorResult: ScreenTimeAuthorizationResult? = nil
    
    var toastMessage: String? = nil
    
    private var toastTask: Task<(), any Error>?
    
    private(set) var appGroups: [AppGroup] = []
    
    private let fetchAppGroupUseCase: FetchAppGroupUseCase
    private let requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase
    
    private let blockScheduleManager: BlockScheduleProtocol = BlockScheduleManager()
    private let breakTimeManager: BreakTimeManager = BreakTimeManager()
    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
    private let timerActor: TimerActor = TimerActor()
    private var timerTask: Task<(), Never>?
    
    public init(
        fetchAppGroupUseCase: FetchAppGroupUseCase,
        requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase
    ) {
        self.fetchAppGroupUseCase = fetchAppGroupUseCase
        self.requestScreenTimeAuthUseCase = requestScreenTimeAuthUseCase
    }
    
    // MARK: - 생명주기 메서드
    
    public func onAppear() {
        Task {
            await refreshAppGroups()
        }
        refreshSessionTimer()
    }
    
    public func sceneActive() {
        Task {
            await screenTimeAuthRequest()
        }
        
        if let scheduleData: Data = self.appScheduleStorage.getBlockScheduleData(forId: scheduleKey),
           let schedule = try? JSONDecoder().decode(BlockSchedule.self, from: scheduleData){
            print("현재 스케쥴 가져오기 성공: \(schedule.title) \(schedule.blockList.applicationTokens.count)")
            self.currentSchedule = schedule
        }
        
        self.timerSettingPresent = self.appScheduleStorage.getSelectedNotification()
        refreshSessionTimer()
    }
    
    // MARK: - UI 이벤트 핸들러
    public func addButtonTapped() {
        addGroupPresent.toggle()
    }
    
    public func editButtonTapped(appGroup: AppGroup) {
        self.editAppGroup = appGroup
    }
    
    public func reAuthButtonTapped() {
        Task {
            await screenTimeAuthRequest()
        }
    }
    
    public func sessionExitButtonTapped() {
        self.sessionExitAlertPresent = true
    }
    
    // MARK: - 비즈니스 로직 메서드
    
    public func deleteCompleted(appGroup: AppGroup) {
        // 기존 스케줄 완전 정리
        cleanupExistingSchedule()
        
        self.currentActiveAppGroup = nil
        self.appGroups = []
        toast(message: "그룹이 삭제되었습니다.")
    }
    
    public func upsertCompleted(appGroup: AppGroup) {
        let message = appGroups.isEmpty ? "그룹이 추가되었습니다." : "그룹이 수정되었습니다."
        // 기존 스케줄 완전 정리
        cleanupExistingSchedule()
        Task {
            do {
                try await Task.sleep(for: .seconds(0.2))
                let schedule = BlockSchedule(
                    id: "\(appGroup.id)",
                    title: appGroup.name,
                    blockList: appGroup.selection,
                    startTime: BlockTime(hour: 00, minute: 00),
                    endTime: BlockTime(hour: 23, minute: 59)
                )
                print("새로 저장할 스케쥴: \(schedule.title) ")
                self.currentSchedule = schedule
                let scheduleData = try JSONEncoder().encode(schedule)
                appScheduleStorage.saveBlockScheduleData(scheduleData, forId: scheduleKey)
                try blockScheduleManager.create(schedule)
            } catch {
                assertionFailure("앱 스케쥴 설정 실패: \(error)")
            }
        }
        
        self.appGroups = [appGroup]
        
        toast(message: message)
    }
    
    // MARK: - 세션 관련 메서드
    
    /// 세션 종료하기 알림 버튼을 누름
    public func sessionExitConfirmBtnTapped() {
        self.sessionEnd()
    }
    
    public func sessionTimerSettingCompletion(selectedTime: Int) {
        do {
            try self.breakTimeManager.createBreakTime(minutes: selectedTime)
            appScheduleStorage.saveSelectNotificationTrigger(false)
            self.brakeStatus = .session
            self.currentActiveAppGroup = appGroups.first
            self.sessionStart(seconds: selectedTime * 60)
            self.timerSettingPresent = false
        } catch DeviceActivityCenterError.intervalTooShort {
            print("휴식 시간이 너무 짧습니다. 최소 15분 이상 설정해주세요.")
        } catch {
            print("휴식 시간 설정 실패: \(error)")
        }
    }
    
    private func sessionEnd() {
        self.breakTimeManager.deleteBreakTime()
        self.currentActiveAppGroup = nil
        appScheduleStorage.saveSelectNotificationTrigger(false)
        self.brakeStatus = .none
        self.sessionExitAlertPresent = false
    }
    
    private func sessionStart(seconds: Int) {
        timerTask = Task {
            let start = self.breakTimeManager.getStartDate()
            let end = self.breakTimeManager.getEndDate()
            await timerActor.startTimer(
                until: end
            ) { [weak self] interval in
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.sessionRestTime = Int(interval)
                    self.sessionRestRatio = 1 - (interval / (end.timeIntervalSince1970 - start.timeIntervalSince1970))
                }
            } onEnd: {
                self.sessionEnd()
            }
        }
    }
    
    private func refreshSessionTimer() {
        self.timerTask = Task {
            if Task.isCancelled {
                await timerActor.stop()
            }
            let start = self.breakTimeManager.getStartDate()
            let end = self.breakTimeManager.getEndDate()
            print("정한 시간: ", end.timeIntervalSince1970 - start.timeIntervalSince1970)
            switch self.brakeStatus {
            case .session, .locked:
                await timerActor.stop()
                await timerActor.startTimer(until: end) { [weak self] interval in
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        sessionRestRatio = 1 - (interval / (end.timeIntervalSince1970 - start.timeIntervalSince1970))
                        sessionRestTime = Int(interval)
                    }
                } onEnd: { [weak self] in
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                    }
                }
            case .none: await self.timerActor.stop()
            }
        }
    }
}

// MARK: - Private Helper Methods
fileprivate extension AppGroupMainViewModel {
    func sessionExit() async {
        await MainActor.run { [weak self] in
            guard let self else { return }
            self.brakeStatus = .locked
        }
    }
    
    func screenTimeAuthRequest() async {
        let result: ScreenTimeAuthorizationResult = await requestScreenTimeAuthUseCase.execute()
        await MainActor.run { [weak self] in
            guard let self else { return }
            self.screenTimeAuthErrorResult = result
            switch result {
            case .approved: screenTimeAuthAlertPresent = false
            default: screenTimeAuthAlertPresent = true
            }
        }
    }
    
    func toast(message: String) {
        self.toastTask?.cancel()
        self.toastMessage = nil
        self.toastTask = Task {
            await MainActor.run { [weak self] in
                guard let self else { return }
                toastMessage = message
            }
            try await Task.sleep(for: .seconds(1))
            await MainActor.run { [weak self] in
                guard let self else { return }
                toastMessage = nil
            }
        }
    }
    
    func refreshAppGroups() async {
        do {
            let appGroup = try await fetchAppGroupUseCase.execute()
            await MainActor.run { [weak self] in
                guard let self else { return }
                if let appGroup {
                    appGroups = [appGroup]
                    self.currentActiveAppGroup = appGroup
                } else {
                    appGroups = []
                }
            }
        } catch {
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.toast(message: "그룹을 불러오는데 실패했습니다.")
            }
        }
    }
    
    func cleanupExistingSchedule() {
        // 스토리지에서 기존 스케줄 삭제
        appScheduleStorage.deleteBlockSchedule(id: scheduleKey)
        
        // 현재 스케줄이 있다면 매니저에서도 삭제
        if let currentSchedule {
            print("기존 스케쥴 정리: \(currentSchedule.title) \(currentSchedule.blockList.applications.count)")
            blockScheduleManager.delete(currentSchedule)
        }
        
        // 모든 블록 스케줄 정리 (추가 안전장치)
//        appScheduleStorage.clearAllBlockSchedules()
        
        // 현재 스케줄 참조 초기화
        self.currentSchedule = nil
    }
    
}
