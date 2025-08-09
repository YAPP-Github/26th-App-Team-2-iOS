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
@MainActor extension AppGroupStorage: @retroactive AppGroupStorageProtocol {
    
    public func getAllAppGroupEntities() async throws -> [AppGroupEntity] {
        let descriptor = FetchDescriptor<AppGroupEntity>()
        do {
            let entities = try context.fetch(descriptor)
            return entities
        } catch {
            throw AppGroupStorageError.entityNotFound
        }
    }
    
    public func getAppGroupEntity(groupID: Int) async throws -> AppGroupEntity {
        let predicate = #Predicate<AppGroupEntity> { $0.groupID == groupID }
        let descriptor = FetchDescriptor<AppGroupEntity>(predicate: predicate)
        guard let appGroup = try? context.fetch(descriptor).first else {
            throw AppGroupStorageError.entityFetchingError
        }
        return appGroup
    }
    
    
    public func appendAppGroupEntity(_ appGroup: AppGroupEntity) async throws {
        context.insert(appGroup)
        do {
            try context.save()
        } catch {
            throw AppGroupStorageError.saveFailed
        }
    }
    
    public func updateAppGroupEntity(_ appGroup: AppGroupEntity) async throws {
        let groupID: Int = appGroup.groupID
        let predicate = #Predicate<AppGroupEntity> { $0.groupID == groupID }
        let descriptor = FetchDescriptor<AppGroupEntity>(predicate: predicate)
        
        guard let existing = try? context.fetch(descriptor).first else {
            throw AppGroupStorageError.updateFailed
        }
        existing.name = appGroup.name
        existing.selectionData = appGroup.selectionData
        do {
            try context.save()
        } catch {
            throw AppGroupStorageError.updateFailed
        }
    }
    
    public func upsertAppGroupEntity(_ appGroup: AppGroupEntity) async throws {
        let groupID: Int = appGroup.groupID
        let predicate = #Predicate<AppGroupEntity> { $0.groupID == groupID }
        let descriptor = FetchDescriptor<AppGroupEntity>(predicate: predicate)
        
        if let entity = try? context.fetch(descriptor).first {
            entity.name = appGroup.name
            entity.selectionData = appGroup.selectionData
        } else {
            context.insert(appGroup)
        }
        do {
            try context.save()
        } catch {
            throw AppGroupStorageError.upsertFailed
        }
    }
    
    public func deleteAppGroupEntity(groupID: Int) async throws {
        let predicate = #Predicate<AppGroupEntity> { $0.groupID == groupID }
        let descriptor = FetchDescriptor<AppGroupEntity>(predicate: predicate)
        do {
            let entities = try context.fetch(descriptor)
            for entity in entities {
                context.delete(entity)
            }
            try context.save()
        } catch {
            throw AppGroupStorageError.deleteFailed
        }
        // 존재하지 않는 엔티티의 경우 조용히 무시 (에러를 던지지 않음)
    }
    
    public func deleteAllAppGroupEntities() async throws {
        let descriptor = FetchDescriptor<AppGroupEntity>()
        do {
            let entities = try context.fetch(descriptor)
            for entity in entities {
                context.delete(entity)
            }
            try context.save()
        } catch {
            throw AppGroupStorageError.deleteFailed
        }
    }
}

