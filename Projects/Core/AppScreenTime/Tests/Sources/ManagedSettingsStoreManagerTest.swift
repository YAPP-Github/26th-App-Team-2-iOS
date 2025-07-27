//
//  ManagedSettingsStoreManagerTest.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 2025/01/27.
//

import Foundation
import Testing
import XCTest
import CoreAppScreenTimeInterface
import CoreAppScreenTime
import FamilyControls

struct ManagedSettingsStoreManagerTest {
    @Test
    func testUpdateBlockList() {
        let manager = ManagedSettingsStoreManager()
        
        let testSchedule = BlockSchedule(
            id: "test-schedule",
            title: "Test Schedule",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 9, minute: 0),
            endTime: BlockTime(hour: 18, minute: 0)
        )
        
        // updateBlockList 메서드가 예외를 던지지 않는지 확인
        XCTAssertNoThrow(manager.updateBlockList(for: testSchedule))
    }
    
    @Test
    func testClearBlockList() {
        let manager = ManagedSettingsStoreManager()
        
        let testSchedule = BlockSchedule(
            id: "test-schedule",
            title: "Test Schedule",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 9, minute: 0),
            endTime: BlockTime(hour: 18, minute: 0)
        )
        
        // clearBlockList 메서드가 정상적으로 실행되는지 확인
        XCTAssertNoThrow(manager.clearBlockList(for: testSchedule))
    }
    
    @Test
    func testUpdateBlockListBasedOnState() {
        let manager = ManagedSettingsStoreManager()
        
        let testSchedule = BlockSchedule(
            id: "test-schedule",
            title: "Test Schedule",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 9, minute: 0),
            endTime: BlockTime(hour: 18, minute: 0)
        )
        
        // 활성 상태일 때
        XCTAssertNoThrow(manager.updateBlockListBasedOnState(for: testSchedule, isActive: true))
        
        // 비활성 상태일 때
        XCTAssertNoThrow(manager.updateBlockListBasedOnState(for: testSchedule, isActive: false))
    }
    
    @Test
    func testUpdateAllBlockLists() {
        let manager = ManagedSettingsStoreManager()
        
        let schedule1 = BlockSchedule(
            id: "schedule-1",
            title: "Schedule 1",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 9, minute: 0),
            endTime: BlockTime(hour: 12, minute: 0)
        )
        
        let schedule2 = BlockSchedule(
            id: "schedule-2",
            title: "Schedule 2",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 14, minute: 0),
            endTime: BlockTime(hour: 18, minute: 0)
        )
        
        let schedules = [schedule1, schedule2]
        
        // 모든 스케줄의 블록 리스트 업데이트
        XCTAssertNoThrow(manager.updateAllBlockLists(schedules: schedules))
    }
    
    @Test
    func testClearAllBlockLists() {
        let manager = ManagedSettingsStoreManager()
        
        let schedule1 = BlockSchedule(
            id: "schedule-1",
            title: "Schedule 1",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 9, minute: 0),
            endTime: BlockTime(hour: 12, minute: 0)
        )
        
        let schedule2 = BlockSchedule(
            id: "schedule-2",
            title: "Schedule 2",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 14, minute: 0),
            endTime: BlockTime(hour: 18, minute: 0)
        )
        
        let schedules = [schedule1, schedule2]
        
        // 모든 스케줄의 블록 리스트 삭제
        XCTAssertNoThrow(manager.clearAllBlockLists(schedules: schedules))
    }
    
    @Test
    func testClearAllBlockListsForRest() {
        let manager = ManagedSettingsStoreManager()
        
        let schedule1 = BlockSchedule(
            id: "schedule-1",
            title: "Schedule 1",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 9, minute: 0),
            endTime: BlockTime(hour: 12, minute: 0)
        )
        
        let schedule2 = BlockSchedule(
            id: "schedule-2",
            title: "Schedule 2",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 14, minute: 0),
            endTime: BlockTime(hour: 18, minute: 0)
        )
        
        let schedules = [schedule1, schedule2]
        
        // 휴식 시 모든 블록 리스트를 비워줌
        XCTAssertNoThrow(manager.clearAllBlockListsForRest(schedules: schedules))
    }
    
    @Test
    func testMultipleOperations() {
        let manager = ManagedSettingsStoreManager()
        
        let testSchedule = BlockSchedule(
            id: "test-schedule",
            title: "Test Schedule",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 9, minute: 0),
            endTime: BlockTime(hour: 18, minute: 0)
        )
        
        // 여러 작업을 순차적으로 실행
        XCTAssertNoThrow(manager.updateBlockList(for: testSchedule))
        XCTAssertNoThrow(manager.updateBlockListBasedOnState(for: testSchedule, isActive: false))
        XCTAssertNoThrow(manager.updateBlockListBasedOnState(for: testSchedule, isActive: true))
        XCTAssertNoThrow(manager.clearBlockList(for: testSchedule))
    }
} 
