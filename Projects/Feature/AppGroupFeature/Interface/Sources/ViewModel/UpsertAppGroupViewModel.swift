//
//  AddAppGroupViewModel.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/28/25.
//

import Foundation
import FamilyControls
import ManagedSettings

import Domain

@Observable
public final class UpsertAppGroupViewModel {
    var appGroupName: String = ""
    var selectionPresent: Bool = false
    var dismiss: Bool = false
    
    var applicationTokens: [ApplicationToken] {
        newSelection.applicationTokens.map { $0 }
    }
    
    private(set) var newSelection: FamilyActivitySelection = .init()
    let upsertCompletion: (AppGroup) -> ()
    let deleteCompletion: ((AppGroup) -> ())?
    let isCreating: Bool
    
    // MARK: -- Private Parameters...
    private let upsertAppGroupUseCase: UpsertAppGroupUseCase
    private let deleteAppGroupUseCase: DeleteAppGroupUseCase?
    private let appGroup: AppGroup?
    
    public init(
        appGroup: AppGroup? = nil,
        upsertAppGroupUseCase: UpsertAppGroupUseCase,
        upsertCompletion: @escaping (AppGroup) -> (),
        deleteAppGroupUseCase: DeleteAppGroupUseCase? = nil,
        deleteCompletion: ((AppGroup) -> ())? = nil
    ) {
        if let appGroup = appGroup {
            self.newSelection = appGroup.selection
            self.appGroupName = appGroup.name
        }
        self.isCreating = (appGroup == nil)
        self.appGroup = appGroup
        self.upsertAppGroupUseCase = upsertAppGroupUseCase
        self.upsertCompletion = upsertCompletion
        self.deleteAppGroupUseCase = deleteAppGroupUseCase
        self.deleteCompletion = deleteCompletion
    }
    
    public func selectionBtnTapped() {
        selectionPresent.toggle()
    }
    
    public func updateSelection(_ selection: FamilyActivitySelection) {
        self.newSelection = selection
    }
    
    public func deleteGroupBtnTapped() {
        Task {
            guard let appGroup, let deleteAppGroupUseCase, let deleteCompletion else { return }
            do {
                try await deleteAppGroupUseCase.execute(appGroupID: appGroup.groupID)
            } catch {
                print("오류가 발생했슈~")
            }
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                deleteCompletion(appGroup)
                dismiss = true
            }
        }
    }
    
    public func upsertCompleteBtnTapped() {
        Task {
            do {
                let newAppGroup = if let appGroup {
                    try await upsertAppGroupUseCase.execute(
                        appGroupID: appGroup.groupID,
                        groupName: appGroupName,
                        activitySelection: newSelection
                    )
                } else {
                    try await upsertAppGroupUseCase.execute(
                        groupName: appGroupName,
                        activitySelection: newSelection
                    )
                }
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    upsertCompletion(newAppGroup)
                    self.dismiss = true
                }
            } catch {
                
            }
        }
    }
}
