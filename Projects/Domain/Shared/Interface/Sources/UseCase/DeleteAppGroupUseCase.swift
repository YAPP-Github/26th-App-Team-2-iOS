//
//  DeleteAppGroupUseCase.swift
//  DomainSharedInterface
//
//  Created by Greem on 7/29/25.
//

import Foundation
import FamilyControls
import Core

public struct DeleteAppGroupUseCase {
    
    private let appGroupService: AppGroupProtocol = AppGroupService(
        appGroupStorage: AppGroupStorage()
    )
    
    public init() { }
    
    public func execute(
        appGroupID: Int
    ) async throws {
        try await appGroupService.deleteAppGroup(groupID: appGroupID)
    }
}



