//
//  AppGroupStorage.swift
//  CoreLocalStorageInterface
//
//  Created by Greem on 7/28/25.
//

import Foundation
import CoreLocalStorageInterface
import SwiftData
import FamilyControls

/// SwiftData ModelContext는 MainActor에서만 동작
@MainActor
public final class AppGroupStorage: @preconcurrency AppGroupStorageProtocol {
    
    let context: ModelContext
    
    public init() throws {
        let container = try ModelContainer(for: AppGroupEntity.self)
        self.context = container.mainContext
    }
    
    public func getAllGroups() throws -> [AppGroup] {
        let descriptor = FetchDescriptor<AppGroupEntity>()
        let entities = try context.fetch(descriptor)
        return try entities.map { try $0.toAppGroup() }
    }
    
    public func getGroup(id: Int) throws -> AppGroup {
        let predicate = #Predicate<AppGroupEntity> { $0.groupID == id }
        let descriptor = FetchDescriptor<AppGroupEntity>(predicate: predicate)
        let result = try context.fetch(descriptor)
        guard let appGroup = try result.first?.toAppGroup() else {
            fatalError("변환 실패")
        }
        return appGroup
    }
    
    
    public func appendGroup(_ appGroup: AppGroup) throws {
        let selectionData = try JSONEncoder().encode(appGroup)
        let entity = AppGroupEntity(
            groupID: appGroup.groupID,
            name: appGroup.name,
            selectionData: selectionData
        )
        context.insert(entity)
        try context.save()
    }
    
    public func upsertGroup(_ appGroup: AppGroup) throws {
        let predicate = #Predicate<AppGroupEntity> { $0.groupID == appGroup.groupID }
        let descriptor = FetchDescriptor<AppGroupEntity>(predicate: predicate)
        let existing = try context.fetch(descriptor).first

        if let entity = existing {
            // 2. 있으면 업데이트
            entity.name = appGroup.name
            entity.selectionData = try JSONEncoder().encode(appGroup.selections)
        } else {
            // 3. 없으면 새로 추가
            let newEntity = try AppGroupEntity(appGroup: appGroup)
            context.insert(newEntity)
        }
        try context.save()
    }
    
    public func deleteGroup(id: Int) throws {
        let predicate = #Predicate<AppGroupEntity> { $0.groupID == id }
        let descriptor = FetchDescriptor<AppGroupEntity>(predicate: predicate)
        if let entity = try context.fetch(descriptor).first {
            context.delete(entity)
            try context.save()
        }
    }
}
