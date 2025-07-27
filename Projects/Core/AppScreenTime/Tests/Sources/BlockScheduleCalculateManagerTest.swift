//
//  BlockScheduleCalculateManagerTest.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 2025/01/27.
//

import Foundation
import Testing
import XCTest
import CoreAppScreenTimeInterface
import CoreAppScreenTime

struct BlockScheduleCalculateManagerTest {
    @Test
    func testCalculate_activeStatus() {
        let manager = BlockScheduleCalculateManager()
        let now = Date()
        let start = BlockTime(date: now.addingTimeInterval(-60)) // 1분 전
        let end = BlockTime(date: now.addingTimeInterval(60))    // 1분 후
        let result = manager.calculate(with: start, and: end)
        XCTAssertEqual(result.currentStatus, .active)
        XCTAssertTrue(result.remainingTime > 0)
    }
    
    @Test
    func testCalculate_restStatus() {
        let manager = BlockScheduleCalculateManager()
        let now = Date()
        let start = BlockTime(date: now.addingTimeInterval(60)) // 1분 후
        let end = BlockTime(date: now.addingTimeInterval(120))  // 2분 후
        let result = manager.calculate(with: start, and: end)
        XCTAssertEqual(result.currentStatus, .rest)
    }
    
    @Test
    func testCalculate_timeInterval() {
        let manager = BlockScheduleCalculateManager()
        let now = Date()
        let start = BlockTime(date: now.addingTimeInterval(-30)) // 30초 전
        let end = BlockTime(date: now.addingTimeInterval(30))    // 30초 후
        let result = manager.calculate(with: start, and: end)
        
        XCTAssertEqual(result.currentStatus, .active)
        XCTAssertTrue(result.remainingTime > 0)
        XCTAssertTrue(result.remainingTime <= 30) // 남은 시간이 30초 이하여야 함
    }
} 
