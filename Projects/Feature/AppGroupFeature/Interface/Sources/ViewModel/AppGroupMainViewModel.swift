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
    var brakeStatus: BrakeStatus = .none
    var addGroupPresent: Bool = false
    
    private var currentSchedule: BlockSchedule?
    var currentActiveAppGroup: AppGroup? = nil
    var editAppGroup: AppGroup? = nil
    var toastMessage: String? = nil
    
    var sessionExitAlertPresent: Bool = false
    
    var screenTimeAuthAlertPresent: Bool = false
    var screenTimeAuthErrorResult: ScreenTimeAuthorizationResult? = nil
    
    private var toastTask: Task<(), any Error>?
    
    private(set) var appGroups: [AppGroup] = []
    
    private let fetchAppGroupUseCase: FetchAppGroupUseCase
    private let requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase
    
    private let blockScheduleManager: BlockScheduleProtocol = BlockScheduleManager()
    
    public init(
        fetchAppGroupUseCase: FetchAppGroupUseCase,
        requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase
    ) {
        self.fetchAppGroupUseCase = fetchAppGroupUseCase
        self.requestScreenTimeAuthUseCase = requestScreenTimeAuthUseCase
        
    }
    
    public func onAppear() {
        Task {
            await refreshAppGroups()
        }
    }
    
    public func sceneActive() {
        Task {
            await screenTimeAuthRequest()
        }
    }
    
    public func reAuthButtonTapped() {
        Task {
            await screenTimeAuthRequest()
        }
    }
    
    public func addButtonTapped() {
        addGroupPresent.toggle()
    }
    
    public func editButtonTapped(appGroup: AppGroup) {
        self.editAppGroup = appGroup
    }
    
    
    public func deleteCompleted(appGroup: AppGroup) {
        if let currentSchedule {
            blockScheduleManager.delete(currentSchedule)
        }
        self.currentSchedule = nil
        self.appGroups = []
        toast(message: "그룹이 삭제되었습니다.")
    }
    
    public func upsertCompleted(appGroup: AppGroup) {
        let message = appGroups.isEmpty ? "그룹이 추가되었습니다." : "그룹이 수정되었습니다."
        do {
            if let currentSchedule {
                blockScheduleManager.delete(currentSchedule)
            }
            let schedule = BlockSchedule(
                id: "\(appGroup.id)",
                title: appGroup.name,
                blockList: appGroup.selection,
                startTime: BlockTime(hour: 00, minute: 00),
                endTime: BlockTime(hour: 23, minute: 59)
            )
            self.currentSchedule = schedule
            try blockScheduleManager.create(schedule)
        } catch {
            assertionFailure("앱 스케쥴 설정 실패: \(error)")
        }
        self.appGroups = [appGroup]
        
        toast(message: message)
    }
    
    public func sessionExitButtonTapped() {
        self.sessionExitAlertPresent = true
    }
    
    /// 세션 종료하기 알림 버튼을 누름
    public func sessionExitConfirmBtnTapped() {
        self.sessionExitAlertPresent = false
        self.brakeStatus = .locked
    }
}

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
}
