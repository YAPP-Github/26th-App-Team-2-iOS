//
//  UpsertAppGroupViewModel.swift
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
    // MARK: - Properties
    var appGroupName: String = ""
    var selectionPresent: Bool = false
    var deleteConfirmPresent: Bool = false
    var dismiss: Bool = false
    
    var applicationTokens: [ApplicationToken] { newSelection.applicationTokens.map { $0 } }
    
    private(set) var newSelection = FamilyActivitySelection(includeEntireCategory: true)
    let upsertCompletion: (AppGroup) -> ()
    let deleteCompletion: ((AppGroup) -> ())?
    let isCreating: Bool
    
    // MARK: - Private Properties
    private let upsertAppGroupUseCase: UpsertAppGroupUseCase
    private let deleteAppGroupUseCase: DeleteAppGroupUseCase?
    private let appGroup: AppGroup?
    
    // MARK: - Initialization
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
    
    // MARK: - Public Methods
    
    public func setAppGroupName(_ name: String) {
        self.appGroupName = String(name.prefix(10))
    }
    
    // MARK: Selection Management
    public func selectionBtnTapped() {
        selectionPresent.toggle()
    }
    
    public func updateSelection(_ selection: FamilyActivitySelection) {
        self.newSelection = selection
    }
    
    public func deleteApplicationBtnTapped(applicationToken: ApplicationToken) {
        self.newSelection.applicationTokens.remove(applicationToken)
    }
    
    // MARK: App Group Management
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
                }
            } catch {
                
            }
        }
    }
    
    // MARK: Delete Management
    public func deleteGroupBtnTapped() {
        self.deleteConfirmPresent = true
    }
    
    public func deleteConfirmBtnTapped() {
        Task {
            guard let appGroup, let deleteAppGroupUseCase, let deleteCompletion else { return }
            do {
                try await deleteAppGroupUseCase.execute(appGroupID: appGroup.groupID)
            } catch {
                assertionFailure("Failed to delete app group: \(error)")
            }
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.deleteConfirmPresent = false
                deleteCompletion(appGroup)
                dismiss = true
            }
        }
    }
}
