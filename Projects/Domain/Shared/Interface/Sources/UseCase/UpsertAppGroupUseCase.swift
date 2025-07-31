//
//  CreateAppGroupUseCase.swift
//  DomainSharedInterface
//
//  Created by Greem on 7/28/25.
//

import Foundation
import FamilyControls
import Core

public struct UpsertAppGroupUseCase {
    
    private let appGroupService: AppGroupProtocol
    
    public init(appGroupService: AppGroupProtocol) {
        self.appGroupService = appGroupService
    }
    
    @discardableResult
    public func execute(
        appGroupID: Int? = nil,
        groupName: String,
        activitySelection: FamilyActivitySelection
    ) async throws -> AppGroup {
        if let appGroupID {
            let appGroup = AppGroup(name: groupName, groupID: appGroupID, selection: activitySelection)
            try await appGroupService.updateAppGroup(appGroup: appGroup)
            return appGroup
        } else {
            return try await appGroupService.createAppGroup(
                groupName: groupName,
                activitySelection: activitySelection
            )
        }
    }
}
