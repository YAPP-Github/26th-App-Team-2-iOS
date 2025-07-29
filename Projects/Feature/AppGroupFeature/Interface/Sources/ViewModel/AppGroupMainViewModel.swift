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
    
    
    public func removeCompleted(appGroup: AppGroup) {
        self.appGroups = []
    }
    public func upsertCompleted(appGroup: AppGroup) {
        self.appGroups = [appGroup]
    }
}

fileprivate extension AppGroupMainViewModel {
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
