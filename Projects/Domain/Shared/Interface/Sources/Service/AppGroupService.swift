//
//  AppGroupService.swift
//  DomainShared
//
//  Created by Greem on 7/28/25.
//

import Foundation
import FamilyControls
import Core

public protocol AppGroupProtocol {
    
    func getAppGroup() async throws -> AppGroup?
    func updateAppGroup(appGroup: AppGroup) async throws
    func createAppGroup(
        groupName: String,
        activitySelection: FamilyActivitySelection
    ) async throws -> AppGroup
}

public final class AppGroupService: AppGroupProtocol {
    
    
    
    private let appGroupStorage: AppGroupStorageProtocol
    
    public init(
        appGroupStorage: AppGroupStorageProtocol
    ) {
        self.appGroupStorage = AppGroupStorage()
    }
    
    public func createAppGroup(
        groupName: String,
        activitySelection: FamilyActivitySelection
    ) async throws -> AppGroup {
        
        let appGroup = AppGroup(
            name: groupName,
            groupID: UUID().hashValue,
            selection: activitySelection
        )
        
        let appGroupEntity = try AppGroupEntity(appGroup: appGroup)
        try await self.appGroupStorage.appendAppGroupEntity(appGroupEntity)
        
        return appGroup
    }
    
    public func updateAppGroup(appGroup: AppGroup) async throws {
        
    }
    
    public func getAppGroup() async throws -> AppGroup? {
        let appGroupEntities = try await self.appGroupStorage.getAllAppGroupEntities()
        guard let appGroupEntity = appGroupEntities.first else {
            return nil
        }
        return try appGroupEntity.toAppGroup()
    }
}
