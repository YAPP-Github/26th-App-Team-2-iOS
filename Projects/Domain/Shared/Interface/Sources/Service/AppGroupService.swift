//
//  AppGroupService.swift
//  DomainShared
//
//  Created by Greem on 7/28/25.
//

import Foundation
import FamilyControls

public protocol AppGroupProtocol {
    func createAppGroup(
        groupName: String,
        activitySelection: FamilyActivitySelection
    ) async throws -> AppGroup
}

public final class AppGroupService: AppGroupProtocol {
    
    public init() {
        
    }
    
    public func createAppGroup(
        groupName: String,
        activitySelection: FamilyActivitySelection
    ) async throws -> AppGroup {
        
        
        
        .init(name: groupName, groupID: -1, selection: activitySelection)
    }
    
    public func getAppGroup() -> AppGroup? {
        return nil
    }
}
