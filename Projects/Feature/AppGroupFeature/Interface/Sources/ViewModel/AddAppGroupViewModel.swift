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
public final class AddAppGroupViewModel {
    
    var newSelection: FamilyActivitySelection = .init()
    var selectionPresent: Bool = false
    var applicationTokens: [ApplicationToken] { newSelection.applicationTokens.map { $0 } }
    
    private let createAppGroupUseCase: CreateAppGroupUseCase
    
    public init(
        createAppGroupUseCase: CreateAppGroupUseCase
    ) {
        self.createAppGroupUseCase = createAppGroupUseCase
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
                try await createAppGroupUseCase.execute(groupName: "Test Group", activitySelection: newSelection)
            } catch {
                
            }
        }
    }
}
