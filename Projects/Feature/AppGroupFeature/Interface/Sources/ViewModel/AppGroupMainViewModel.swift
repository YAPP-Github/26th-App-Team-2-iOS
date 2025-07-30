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
    var toastTask: Task<(), any Error>?
    
    private(set) var appGroups: [AppGroup] = []
    
    private let fetchAppGroupUseCase: FetchAppGroupUseCase
    public init(
        fetchAppGroupUseCase: FetchAppGroupUseCase
    ) {
        self.fetchAppGroupUseCase = fetchAppGroupUseCase
    }
    
    public func onAppear() {
        Task {
            await refreshAppGroups()
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
            print("알 수 없는 에러 발생")
        }
    }
}
