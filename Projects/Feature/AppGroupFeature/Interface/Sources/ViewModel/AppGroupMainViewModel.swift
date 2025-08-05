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

public enum AppScene {
    case active
    case inActive
    case background
}

@Observable
public final class AppGroupMainViewModel {
    
    var brakeStatus: BrakeStatus {
        get { BrakeStatus(rawValue: UserDefaults.standard.integer(forKey: "brakeStatus")) ?? .none }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "brakeStatus") }
    }
    
    private let scheduleKey: String = "BlockScheduleCurrent"
    private var currentSchedule: BlockScheduleEntity?
    var currentActiveAppGroup: AppGroup? = nil
    var sessionExitAlertPresent: Bool = false
    var timerSettingPresent: Bool = false
    var sessionRestRatio: Double = 0.0
    var sessionRestTime: Int = 0
    
    var editAppGroup: AppGroup? = nil
    var addGroupPresent: Bool = false
    var appBrakeTimeSettingPresent: Bool = false
    var toastMessage: String? = nil
    
    
    var screenTimeAuthAlertPresent: Bool = false
    var brakeTimeSettingCompletePresent: Bool = false
    var screenTimeAuthErrorResult: ScreenTimeAuthorizationResult? = nil
    
    // 앱 정보 저장
    var selectedAppName: String = ""
    

    private var toastTask: Task<(), any Error>?
    
    private var appScene: AppScene = .active

    private(set) var appGroups: [AppGroup] = []

    private let blockScheduleManager: BlockScheduleProtocol = BlockScheduleManager()
    private let breakTimeManager: BreakTimeManager = BreakTimeManager()
    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
    
    private let timerActor: TimerActor = TimerActor()
    private var timerTask: Task<(), Never>?
    
    private let fetchAppGroupUseCase: FetchAppGroupUseCase
    private let requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase
    private let fetchSelectedNotificationUseCase: FetchSelectedNotificationUseCaseProtocol
    

    private let createBlockScheduleUseCase: CreateBlockScheduleUseCaseProtocol
    private let deleteBlockScheduleUseCase: DeleteBlockScheduleUseCaseProtocol
    private let fetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol
    private let endBlockScheduleUseCase: EndBlockScheduleUseCaseProtocol
    private let getBlockingStatusUseCase: GetBlockingStatusUseCaseProtocol
    
    private let endBreakTimeUseCase: EndBreakTimeUseCaseProtocol
    
    
    
    public init(
        fetchAppGroupUseCase: FetchAppGroupUseCase,
        requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase,
        fetchSelectedNotificationUseCase: FetchSelectedNotificationUseCaseProtocol,
        
        createBlockScheduleUseCase: CreateBlockScheduleUseCaseProtocol,
        deleteBlockScheduleUseCase: DeleteBlockScheduleUseCaseProtocol,
        fetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol,
        endBlockScheduleUseCase: EndBlockScheduleUseCaseProtocol,
        getBlockingStatusUseCase: GetBlockingStatusUseCaseProtocol,
        endBreakTimeUseCase: EndBreakTimeUseCaseProtocol
    ) {
        self.fetchAppGroupUseCase = fetchAppGroupUseCase
        self.requestScreenTimeAuthUseCase = requestScreenTimeAuthUseCase
        self.fetchSelectedNotificationUseCase = fetchSelectedNotificationUseCase
        
        
        self.createBlockScheduleUseCase = createBlockScheduleUseCase
        self.deleteBlockScheduleUseCase = deleteBlockScheduleUseCase
        self.fetchBlockScheduleUseCase = fetchBlockScheduleUseCase
        self.endBlockScheduleUseCase = endBlockScheduleUseCase
        self.getBlockingStatusUseCase = getBlockingStatusUseCase
        
        self.endBreakTimeUseCase = endBreakTimeUseCase
    }
    
    // MARK: - 생명주기 메서드

//
    public func onAppear() {
        self.appScene = .inActive
        Task(priority: .high) {
            await refreshAppGroups()
            loadAppBrakeTimeNotificationSetting()
        }
//        refreshSessionTimer()
    }
    
    public func setScene(_ scene: AppScene) {
        self.appScene = scene
        switch scene {
        case .active:
            sceneActive()
        case .inActive: break
        case .background: break
        }
    }
    
    

    private func sceneActive() {
        Task(priority: .background) { await screenTimeAuthRequest() }
        Task(priority: .high) {
            if let appGroup = try await fetchAppGroupUseCase.execute(),
               let schedule = fetchBlockScheduleUseCase.execute(activityName: "\(appGroup.groupID)") {
                let status = getBlockingStatusUseCase.execute(tokenName: "\(appGroup.groupID)")
                print("현재 상태: \(status) | 지금 시간: \(Date.now)")
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.currentSchedule = schedule
                    self.timerSettingPresent = self.appScheduleStorage.getSelectedNotification()
                    switch status {
                    case .blocking, .unlockedTemporarily:
                        self.brakeStatus = .none
                    case .extensionPrompt(_, _, let startDate, let endDate):
                        if .now < startDate {
                            self.brakeStatus = .session
                            let endDate = self.breakTimeManager.getEndDate()
                            let startDate = self.breakTimeManager.getStartDate()
                            refreshSessionTimer(start: startDate, end: endDate)
                        } else if startDate < .now && .now < endDate {
                            self.brakeStatus = .locked
                            refreshSessionTimer(start: .now, end: endDate)
                        } else {
                            self.brakeStatus = .none
                        }
                    case .sessionEnded(let time, let groupName): self.brakeStatus = .locked
                    case .cooldownActive(let tokenName, let time, let groupName):
                        self.brakeStatus = .locked
                    }
                }
            } else {
                print("스케쥴 fetch 실패")
            }
            await refreshAppGroups()
        }
    }
    
    // MARK: - UI 이벤트 핸들러
    public func addButtonTapped() {
        addGroupPresent.toggle()
    }

    public func editButtonTapped(appGroup: AppGroup) {
        self.editAppGroup = appGroup
    }

    private func loadAppBrakeTimeNotificationSetting() {
        Task {
            do {
                appBrakeTimeSettingPresent = try await fetchSelectedNotificationUseCase.execute()
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.toast(message: "알림 설정을 불러오는데 실패했습니다.")
                }
            }
        }
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
                /// BlockScheduleEntity에 시간의 제한이 있는게 맞는 것인가?
                let blockScheduleEntity = BlockScheduleEntity(
                    id: "\(appGroup.groupID)",
                    title: appGroup.name,
                    blockList: appGroup.selection,
                    startTime: .init(hour: 00, minute: 00),
                    endTime: .init(hour: 23, minute: 59)
                )
                try createBlockScheduleUseCase.execute(schedule: blockScheduleEntity)
                self.currentSchedule = blockScheduleEntity
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
        do {
            guard let currentSchedule else {
                assertionFailure("현재 스케쥴이 없는데 부름!!")
                return
            }
            try self.endBreakTimeUseCase.execute()
            appScheduleStorage.saveSelectNotificationTrigger(false)
            self.brakeStatus = .locked
            refreshSessionTimer(start: .now, end: .now.addingTimeInterval(15 * 60))
            self.sessionExitAlertPresent = false
        } catch {
            print("끝내는데 오류가 발생함: \(error.localizedDescription)")
        }
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
    
    private func refreshSessionTimer(start: Date, end: Date) {
        self.timerTask = Task {
            if Task.isCancelled {
                await timerActor.stop()
            }
            guard self.brakeStatus != .none else {
                await self.timerActor.stop()
                return
            }
            await timerActor.stop()
            await timerActor.startTimer(until: end) { [weak self] interval in
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    sessionRestRatio = 1 - (interval / (end.timeIntervalSince1970 - start.timeIntervalSince1970))
                    sessionRestTime = Int(interval)
                }
            } onEnd: { [weak self, breakStatus = self.brakeStatus] in
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    switch breakStatus {
                    case .locked:
                        self.brakeStatus = .none
                    case .session:
                        brakeStatus = .locked
                        refreshSessionTimer(start: .now, end: .now.addingTimeInterval(60 * 15))
                    case .none: break
                    }
                }
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
                guard let self else {
                    return
                }
                if let appGroup {
                    self.appGroups = [appGroup]
                    self.currentActiveAppGroup = appGroup
                } else {
                    self.appGroups = []
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
//        appScheduleStorage.deleteBlockSchedule(id: scheduleKey)
        if let currentSchedule {
            deleteBlockScheduleUseCase.execute(schedule: currentSchedule)
        }
        
        // 모든 블록 스케줄 정리 (추가 안전장치)
//        appScheduleStorage.clearAllBlockSchedules()
        
        // 현재 스케줄 참조 초기화
        self.currentSchedule = nil
    }
    
}
