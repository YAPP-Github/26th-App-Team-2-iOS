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
    let createCompletion: (AppGroup) -> ()
    
    // MARK: -- Private Parameters...
    private let createAppGroupUseCase: CreateAppGroupUseCase
    private let appGroup: AppGroup?
    
    public init(
        appGroup: AppGroup? = nil,
        createAppGroupUseCase: CreateAppGroupUseCase,
        createCompletion: @escaping (AppGroup) -> ()
    ) {
        if let appGroup = appGroup {
            self.newSelection = appGroup.selection
            self.appGroupName = appGroup.name
        }
        self.appGroup = appGroup
        self.createAppGroupUseCase = createAppGroupUseCase
        self.createCompletion = createCompletion
    }
    
    public func selectionBtnTapped() {
        selectionPresent.toggle()
    }
    
    public func updateSelection(_ selection: FamilyActivitySelection) {
        self.newSelection = selection
    }
    
    public func addBtnTapped() {
        Task {
            do {
                let newAppGroup = if let appGroup {
                    try await createAppGroupUseCase.execute(
                        groupName: appGroupName,
                        activitySelection: newSelection
                    )
                } else {
                    try await createAppGroupUseCase.execute(
                        groupName: appGroupName,
                        activitySelection: newSelection
                    )
                }
                print("앱 그룹 추가 성공")
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    createCompletion(newAppGroup)
                    dismiss = true
                }
            } catch {
                
            }
        }
    }
}
