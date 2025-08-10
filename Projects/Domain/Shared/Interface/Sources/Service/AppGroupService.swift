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
    func deleteAppGroup(groupID: Int) async throws
    func deleteAllAppGroup() async throws
}

enum AppGroupServiceError: Error {
    case storageNotExist
}

public final class AppGroupService: AppGroupProtocol {
    
    
    
    private let appGroupStorage: AppGroupStorageProtocol?
    
    public init(
        appGroupStorage: AppGroupStorageProtocol?
    ) {
        self.appGroupStorage = appGroupStorage
    }
    
    public func createAppGroup(
        groupName: String,
        activitySelection: FamilyActivitySelection
    ) async throws -> AppGroup {
        guard let appGroupStorage else {
            throw AppGroupServiceError.storageNotExist
        }
        let appGroup = AppGroup(
            name: groupName,
            groupID: Int(Date().timeIntervalSince1970 * 1000),
            selection: activitySelection
        )
        let appGroupEntity = try AppGroupEntity(appGroup: appGroup)
        try await appGroupStorage.appendAppGroupEntity(appGroupEntity)
        
        return appGroup
    }
    
    public func updateAppGroup(appGroup: AppGroup) async throws {
        guard let appGroupStorage else {
            throw AppGroupServiceError.storageNotExist
        }
        let appGroupEntity = try AppGroupEntity(appGroup: appGroup)
        try await appGroupStorage.updateAppGroupEntity(appGroupEntity)
    }
    
    public func getAppGroup() async throws -> AppGroup? {
        guard let appGroupStorage else {
            throw AppGroupServiceError.storageNotExist
        }
        let appGroupEntities = try await appGroupStorage.getAllAppGroupEntities()
        guard let appGroupEntity = appGroupEntities.first else {
            return nil
        }
        return try appGroupEntity.toAppGroup()
    }
    
    public func deleteAppGroup(groupID: Int) async throws {
        guard let appGroupStorage else {
            throw AppGroupServiceError.storageNotExist
        }
        try await appGroupStorage.deleteAppGroupEntity(groupID: groupID)
    }
    public func deleteAllAppGroup() async throws {
        guard let appGroupStorage else {
            throw AppGroupServiceError.storageNotExist
        }
        try await appGroupStorage.deleteAllAppGroupEntities()
    }
}
