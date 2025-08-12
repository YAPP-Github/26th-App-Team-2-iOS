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
    private var brakeStatusStorage: BrakeStatus {
        get { BrakeStatus(rawValue: UserDefaults.standard.integer(forKey: "brakeStatus")) ?? .none }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "brakeStatus") }
    }
    // MARK: -- Present, ScreenCover, Toast Message
    var addGroupPresent: Bool = false // 처음 생성할 앱 그룹 관리
    var editAppGroup: AppGroup? = nil // 수정할 앱 그룹 관리
    var appBrakeTimeSettingPresent: Bool = false // 외부에서 앱 허용하기 시간 설정 팝업 Sheet
    var toastMessage: String? = nil // 토스트 메시지 팝업
    var sessionExitAlertPresent: Bool = false // 차단앱 허용 상태 종료하기 팝업 Sheet
    
    // MARK: -- View Status
    private(set) var appGroups: [AppGroup] = [] // 앱의 그룹들을 나타냄
    private(set) var brakeStatus: BrakeStatus = .none // 앱 차단 상태
    private(set) var currentActiveAppGroup: AppGroup? = nil
    
    private(set) var sessionRestRatio: Double = 0.0 // 타이머 지난 흐름 표시
    private(set) var sessionRestTime: Int = 0 // 타이머 시간 표시
    
    // MARK: -- 내부 상태 관리
    private var appScene: AppScene = .background
    private var currentSchedule: BlockScheduleEntity?
    private var timerTask: Task<(), Never>?
    private var toastTask: Task<(), any Error>?
    
    private let blockScheduleManager: BlockScheduleProtocol = BlockScheduleManager()
    private let breakTimeManager: BreakTimeManager = BreakTimeManager()
    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
    private let timerActor: TimerActor = TimerActor()
    
    
    // MARK: -- 외부에서 전달 받은 UseCase
    private let fetchAppGroupUseCase: FetchAppGroupUseCase
    private let fetchSelectedNotificationUseCase: FetchSelectedNotificationUseCaseProtocol
    private let createBlockScheduleUseCase: CreateBlockScheduleUseCaseProtocol
    private let deleteBlockScheduleUseCase: DeleteBlockScheduleUseCaseProtocol
    private let fetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol
    private let endBlockScheduleUseCase: EndBlockScheduleUseCaseProtocol
    private let getBlockingStatusUseCase: GetBlockingStatusUseCaseProtocol
    private let endBreakTimeUseCase: EndBreakTimeUseCaseProtocol
    
    public init(
        fetchAppGroupUseCase: FetchAppGroupUseCase,
        fetchSelectedNotificationUseCase: FetchSelectedNotificationUseCaseProtocol,
        createBlockScheduleUseCase: CreateBlockScheduleUseCaseProtocol,
        deleteBlockScheduleUseCase: DeleteBlockScheduleUseCaseProtocol,
        fetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol,
        endBlockScheduleUseCase: EndBlockScheduleUseCaseProtocol,
        getBlockingStatusUseCase: GetBlockingStatusUseCaseProtocol,
        endBreakTimeUseCase: EndBreakTimeUseCaseProtocol
    ) {
        self.fetchAppGroupUseCase = fetchAppGroupUseCase
        self.fetchSelectedNotificationUseCase = fetchSelectedNotificationUseCase
        self.createBlockScheduleUseCase = createBlockScheduleUseCase
        self.deleteBlockScheduleUseCase = deleteBlockScheduleUseCase
        self.fetchBlockScheduleUseCase = fetchBlockScheduleUseCase
        self.endBlockScheduleUseCase = endBlockScheduleUseCase
        self.getBlockingStatusUseCase = getBlockingStatusUseCase
        self.endBreakTimeUseCase = endBreakTimeUseCase
    }
    
    // MARK: - 생명주기 메서드
    
    public func onAppear() {
        print("OnAppear - storage: \(self.brakeStatusStorage) | status: \(self.brakeStatus)")
        self.brakeStatus = self.brakeStatusStorage
        Task(priority: .high) {
            await refreshAppGroups()
            loadAppBrakeTimeNotificationSetting()
        }
    }
    
    public func onDisAppear() {
        print("OnDisAppear - storage: \(self.brakeStatusStorage) | status: \(self.brakeStatus)")
        self.brakeStatusStorage = brakeStatus
    }
    
    public func setScene(_ scene: AppScene) {
        self.appScene = scene
        switch scene {
        case .active:
            print("Active - storage: \(self.brakeStatusStorage) | status: \(self.brakeStatus)")
            self.brakeStatus = self.brakeStatusStorage // 스토리지에 있는 값을 가져옴
            sceneActive()
        case .inActive:
            print("inActive - storage: \(self.brakeStatusStorage) | status: \(self.brakeStatus)")
            self.brakeStatusStorage = brakeStatus // 현재 상태를 스토리지에 넣음
        case .background: break
        }
    }
    
    private func sceneActive() {
        Task(priority: .high) {
            if let appGroup = try await fetchAppGroupUseCase.execute(),
               let schedule: BlockScheduleEntity = fetchBlockScheduleUseCase.execute(activityName: "\(appGroup.groupID)") {
                let status: BlockingStatusEntity = getBlockingStatusUseCase.execute(tokenName: "\(appGroup.groupID)")
                print("현재 상태: \(status) | 지금 시간: \(Date.now)")
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.currentSchedule = schedule
                    
                    switch status {
                    case .blocking, .unlockedTemporarily: self.brakeStatus = .none
                    case .extensionPrompt(_, _, let startDate, let endDate):
                        if .now < startDate {
                            print("시작시간이 현재보다 짧다")
                            self.brakeStatus = .session
                            let endDate = self.breakTimeManager.getEndDate()
                            let startDate = self.breakTimeManager.getStartDate()
                            refreshSessionTimer(start: startDate, end: endDate)
                        } else if startDate < .now && .now < endDate {
                            print("시작시간과 끝 시간 사이이다.")
                            self.brakeStatus = .locked
                            refreshSessionTimer(start: startDate, end: endDate)
                        } else {
                            self.brakeStatus = .none
                        }
                    case .cooldownActive(_, _, _, let startDate, let endDate):
                        self.brakeStatus = .locked
                        refreshSessionTimer(start: startDate, end: endDate)
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
        addGroupPresent = true
    }
    
    public func editButtonTapped(appGroup: AppGroup) {
        self.editAppGroup = appGroup
    }
    
    public func sessionExitButtonTapped() {
        self.sessionExitAlertPresent = true
    }
    public func sessionExitConfirmBtnTapped() {
        self.sessionEnd()
    }
    
    public func sessionTimerSettingCompletion(selectedTime: Int) {
        self.brakeStatus = .session
        self.currentActiveAppGroup = appGroups.first
        self.sessionStart(seconds: selectedTime * 60)
        self.appBrakeTimeSettingPresent = false
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
}

fileprivate extension AppGroupMainViewModel {
    // MARK: - 세션 관련 메서드
    private func sessionEnd() {
        do {
            guard let currentSchedule else {
                assertionFailure("현재 스케쥴이 없는데 부름!!")
                return
            }
            let currentAppGroupName = self.currentActiveAppGroup?.name ?? ""
            try self.endBreakTimeUseCase.execute()
            appScheduleStorage.saveSelectNotificationTrigger(false)
            self.brakeStatus = .locked
            refreshSessionTimer(start: .now, end: .now.addingTimeInterval(15 * 60))
            self.sessionExitAlertPresent = false
            self.toast(message: "\(currentAppGroupName) 사용 종료!\n이제 \(currentAppGroupName) 앱을 사용할 수 없어요.")
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
        self.timerTask?.cancel()
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
        if let currentSchedule {
            deleteBlockScheduleUseCase.execute(schedule: currentSchedule)
        }
        // 현재 스케줄 참조 초기화
        self.currentSchedule = nil
    }
    
}
