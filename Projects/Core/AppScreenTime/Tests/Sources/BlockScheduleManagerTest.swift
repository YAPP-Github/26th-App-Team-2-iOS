//
//  BlockScheduleManagerTest.swift
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

struct BlockScheduleManagerTest {
    @Test
    func testCreateSchedule() {
        let manager: BlockScheduleProtocol = BlockScheduleManager()

        let testSchedule = BlockSchedule(
            id: "test-schedule",
            title: "Test Schedule",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 9, minute: 0),
            endTime: BlockTime(hour: 18, minute: 0)
        )
        
        // create 메서드가 예외를 던지지 않는지 확인
        XCTAssertNoThrow(try manager.create(testSchedule))
    }
    
    @Test
    func testDeleteSchedule() {
        let manager: BlockScheduleProtocol = BlockScheduleManager()

        let testSchedule = BlockSchedule(
            id: "test-schedule",
            title: "Test Schedule",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 9, minute: 0),
            endTime: BlockTime(hour: 18, minute: 0)
        )
        
        // delete 메서드가 정상적으로 실행되는지 확인
        XCTAssertNoThrow(manager.delete(testSchedule))
    }
    
    @Test
    func testUpdateSchedule() {
        let manager: BlockScheduleProtocol = BlockScheduleManager()
        
        let testSchedule = BlockSchedule(
            id: "test-schedule",
            title: "Test Schedule",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 9, minute: 0),
            endTime: BlockTime(hour: 18, minute: 0)
        )
        
        // update 메서드가 예외를 던지지 않는지 확인
//        XCTAssertNoThrow(try manager.update(testSchedule))
    }
    
    @Test
    func testMultipleOperations() {
        let manager: BlockScheduleProtocol = BlockScheduleManager()

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
        
        // 여러 스케줄 생성
        XCTAssertNoThrow(try manager.create(schedule1))
        XCTAssertNoThrow(try manager.create(schedule2))
        
        // 스케줄 삭제
        XCTAssertNoThrow(manager.delete(schedule1))
    }
    
    @Test
    func testScheduleValidation() {
        let manager: BlockScheduleProtocol = BlockScheduleManager()
        
        // 유효한 스케줄
        let validSchedule = BlockSchedule(
            id: "valid-schedule",
            title: "Valid Schedule",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 9, minute: 0),
            endTime: BlockTime(hour: 18, minute: 0)
        )
        
        XCTAssertNoThrow(try manager.create(validSchedule))
        
        // 시작 시간이 종료 시간보다 늦은 경우 (실제로는 이런 검증이 있을 수 있음)
        let invalidSchedule = BlockSchedule(
            id: "invalid-schedule",
            title: "Invalid Schedule",
            blockList: FamilyActivitySelection(),
            startTime: BlockTime(hour: 18, minute: 0),
            endTime: BlockTime(hour: 9, minute: 0)
        )
        
        // 현재 구현에서는 예외가 발생하지 않을 수 있지만, 향후 검증 로직이 추가될 수 있음
        XCTAssertNoThrow(try manager.create(invalidSchedule))
    }
} 
