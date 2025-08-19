//
//  AppGroupStorageTest.swift
//  CoreLocalStorageTests
//
//  Created by Greem on 7/28/25.
//

import Foundation
import Testing
import FamilyControls

import CoreLocalStorageInterface
import CoreLocalStorage
import CoreLocalStorageTesting

@Suite(.serialized)
struct AppGroupStorageTest {
    
    @MainActor
    let storage = MockAppGroupStorage()
    
    @Test("앱 그룹 생성 테스트")
    func testCreateAppGroup() async throws {
        // Given
        let groupID = 12345
        let groupName = "테스트 그룹"
        let selectionData = try JSONEncoder().encode(FamilyActivitySelection())
        let appGroupEntity = AppGroupEntity(
            groupID: groupID,
            name: groupName,
            selectionData: selectionData
        )
        
        // When
        try await storage.appendAppGroupEntity(appGroupEntity)
        
        // Then
        let retrievedEntity = try await storage.getAppGroupEntity(groupID: groupID)
        #expect(retrievedEntity.groupID == groupID)
        #expect(retrievedEntity.name == groupName)
        #expect(retrievedEntity.selectionData == selectionData)
    }
    
    @Test("모든 앱 그룹 조회 테스트")
    func testGetAllAppGroups() async throws {
        // Given
        let group1 = AppGroupEntity(
            groupID: 1,
            name: "그룹 1",
            selectionData: try JSONEncoder().encode(FamilyActivitySelection())
        )
        let group2 = AppGroupEntity(
            groupID: 2,
            name: "그룹 2",
            selectionData: try JSONEncoder().encode(FamilyActivitySelection())
        )
        
        // When
        try await storage.appendAppGroupEntity(group1)
        try await storage.appendAppGroupEntity(group2)
        
        // Then
        let allGroups = try await storage.getAllAppGroupEntities()
        #expect(allGroups.count == 2)
        
        let groupIDs = allGroups.map { $0.groupID }
        #expect(groupIDs.contains(1))
        #expect(groupIDs.contains(2))
    }
    
    @Test("특정 앱 그룹 조회 테스트")
    func testGetSpecificAppGroup() async throws {
        // Given
        let targetGroupID = 999
        let groupName = "타겟 그룹"
        let appGroupEntity = AppGroupEntity(
            groupID: targetGroupID,
            name: groupName,
            selectionData: try JSONEncoder().encode(FamilyActivitySelection())
        )
        
        // When
        try await storage.appendAppGroupEntity(appGroupEntity)
        
        // Then
        let retrievedEntity = try await storage.getAppGroupEntity(groupID: targetGroupID)
        #expect(retrievedEntity.groupID == targetGroupID)
        #expect(retrievedEntity.name == groupName)
    }
    
    @Test("앱 그룹 업데이트 테스트")
    func testUpsertAppGroup() async throws {
        // Given
        let groupID = 777
        let originalName = "원본 그룹"
        let updatedName = "업데이트된 그룹"
        
        let originalEntity = AppGroupEntity(
            groupID: groupID,
            name: originalName,
            selectionData: try JSONEncoder().encode(FamilyActivitySelection())
        )
        
        // When - 처음 생성
        try await storage.upsertAppGroupEntity(originalEntity)
        
        // Then - 생성 확인
        let createdEntity = try await storage.getAppGroupEntity(groupID: groupID)
        #expect(createdEntity.name == originalName)
        
        // When - 업데이트
        let updatedEntity = AppGroupEntity(
            groupID: groupID,
            name: updatedName,
            selectionData: try JSONEncoder().encode(FamilyActivitySelection())
        )
        try await storage.upsertAppGroupEntity(updatedEntity)
        
        // Then - 업데이트 확인
        let finalEntity = try await storage.getAppGroupEntity(groupID: groupID)
        #expect(finalEntity.name == updatedName)
        
        // 전체 개수는 여전히 1개여야 함
        let allGroups = try await storage.getAllAppGroupEntities()
        #expect(allGroups.count == 1)
    }
    
    @Test("앱 그룹 삭제 테스트")
    func testDeleteAppGroup() async throws {
        // Given
        let groupID = 555
        let appGroupEntity = AppGroupEntity(
            groupID: groupID,
            name: "삭제될 그룹",
            selectionData: try JSONEncoder().encode(FamilyActivitySelection())
        )
        
        // When - 생성
        try await storage.appendAppGroupEntity(appGroupEntity)
        
        // Then - 생성 확인
        let createdEntity = try await storage.getAppGroupEntity(groupID: groupID)
        #expect(createdEntity.groupID == groupID)
        
        // When - 삭제
        try await storage.deleteAppGroupEntity(groupID: groupID)
        
        // Then - 삭제 확인 (존재하지 않는 그룹 조회 시 에러 발생)
        
        // 전체 그룹 개수도 0개여야 함
        let allGroups = try await storage.getAllAppGroupEntities()
        #expect(allGroups.isEmpty)
    }
    
    @Test("존재하지 않는 앱 그룹 삭제 테스트")
    func testDeleteNonExistentAppGroup() async throws {
        // Given
        let nonExistentGroupID = 9999
        
        // When & Then - 존재하지 않는 그룹 삭제 시 에러가 발생하지 않아야 함
        try await storage.deleteAppGroupEntity(groupID: nonExistentGroupID)
        
        // 전체 그룹 개수는 여전히 0개여야 함
        let allGroups = try await storage.getAllAppGroupEntities()
        #expect(allGroups.isEmpty)
    }
}
