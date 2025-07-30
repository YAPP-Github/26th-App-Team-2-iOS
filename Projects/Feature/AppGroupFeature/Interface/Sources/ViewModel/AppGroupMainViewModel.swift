//
//  AppGroupMainViewModel.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/28/25.
//

import Foundation
import Domain

extension AppGroup: @retroactive Identifiable {
    public var id: Int { self.groupID }
}

@Observable
public final class AppGroupMainViewModel {
    
    var addGroupPresent: Bool = false
    var editAppGroup: AppGroup? = nil
    var toastMessage: String? = nil
    var screenTimeAuthAlertPresent: Bool = false
    var screenTimeAuthErrorResult: ScreenTimeAuthorizationResult? = nil
    
    private var toastTask: Task<(), any Error>?
    
    private(set) var appGroups: [AppGroup] = []
    
    private let fetchAppGroupUseCase: FetchAppGroupUseCase
    private let requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase
    
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
        self.appGroups = []
        toast(message: "그룹이 삭제되었습니다.")
    }
    
    public func upsertCompleted(appGroup: AppGroup) {
        let message = appGroups.isEmpty ? "그룹이 추가되었습니다." : "그룹이 수정되었습니다."
        self.appGroups = [appGroup]
        toast(message: message)
    }
}

fileprivate extension AppGroupMainViewModel {
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
