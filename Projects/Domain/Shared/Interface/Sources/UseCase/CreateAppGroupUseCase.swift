//
//  CreateAppGroupUseCase.swift
//  DomainSharedInterface
//
//  Created by Greem on 7/28/25.
//

import Foundation
import FamilyControls


public struct CreateAppGroupUseCase {
    
    private let appGroupService: AppGroupProtocol = AppGroupService()
    public init() {
        
    }
    
    public func execute(
        groupName: String,
        activitySelection: FamilyActivitySelection
    ) async {
    }
}
