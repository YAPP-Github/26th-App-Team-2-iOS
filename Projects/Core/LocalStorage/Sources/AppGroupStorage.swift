//
//  AppGroupStorage.swift
//  CoreLocalStorageInterface
//
//  Created by Greem on 7/28/25.
//

import Foundation
import SwiftData
import FamilyControls
import CoreLocalStorageInterface

/// SwiftData ModelContext는 MainActor에서만 동작
extension AppGroupStorage: @retroactive AppGroupStorageProtocol { }

extension AppGroupStorageProtocol {
    public func getAllAppGroupEntities() async throws -> [AppGroupEntity] {
        let descriptor = FetchDescriptor<AppGroupEntity>()
        let entities = try context.fetch(descriptor)
        return entities
    }
    
    public func getAppGroupEntity(groupID: Int) async throws -> AppGroupEntity {
        let predicate = #Predicate<AppGroupEntity> { $0.groupID == groupID }
        let descriptor = FetchDescriptor<AppGroupEntity>(predicate: predicate)
        let result = try? context.fetch(descriptor)
        guard let appGroup = result?.first else {
            throw AppGroupEntityError.notExist
        }
        return appGroup
    }
    
    
    public func appendAppGroupEntity(_ appGroup: AppGroupEntity) async throws {
        context.insert(appGroup)
        try context.save()
    }
    
    public func updateAppGroupEntity(_ appGroup: AppGroupEntity) async throws {
        let groupID: Int = appGroup.groupID
        let predicate = #Predicate<AppGroupEntity> { $0.groupID == groupID }
        let descriptor = FetchDescriptor<AppGroupEntity>(predicate: predicate)
        do {
            guard let existing = try? context.fetch(descriptor).first else {
                throw AppGroupEntityError.notExist
            }
            existing.name = appGroup.name
            existing.selectionData = appGroup.selectionData
            try context.save()
        }
    }
    
    public func upsertAppGroupEntity(_ appGroup: AppGroupEntity) async throws {
        let groupID: Int = appGroup.groupID
        let predicate = #Predicate<AppGroupEntity> { $0.groupID == groupID }
        let descriptor = FetchDescriptor<AppGroupEntity>(predicate: predicate)
        
        let existing = try? context.fetch(descriptor).first

        if let entity = existing {
            // 2. 있으면 업데이트
            entity.name = appGroup.name
            entity.selectionData = appGroup.selectionData
        } else {
            // 3. 없으면 새로 추가
            context.insert(appGroup)
        }
        try context.save()
    }
    
    public func deleteAppGroupEntity(groupID: Int) async throws {
        let predicate = #Predicate<AppGroupEntity> { $0.groupID == groupID }
        let descriptor = FetchDescriptor<AppGroupEntity>(predicate: predicate)
        if let entity = try context.fetch(descriptor).first {
            context.delete(entity)
            try context.save()
        }
        // 존재하지 않는 엔티티의 경우 조용히 무시 (에러를 던지지 않음)
    }
}
