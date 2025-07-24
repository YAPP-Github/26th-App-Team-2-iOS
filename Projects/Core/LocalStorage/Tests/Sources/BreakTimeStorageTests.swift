//
//  BreakTimeStorageTests.swift
//  CoreLocalStorage
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation
import CoreLocalStorageInterface
import CoreLocalStorage
import Testing

struct BreakTimeStorageTests {
    @Test
    func breakTimeStorage_save_get_delete() {
        let testSuiteName = "test.group.yapp.breake.brake"
        var storage = BreakTimeStorage()
        storage.userDefaults = UserDefaults(suiteName: testSuiteName)
        storage.delete() // 초기화

        // 1. 저장
        storage.saveEndTime(5) // 5분 후
        let endTime = storage.getEndTime()
        #expect(endTime != nil)
        if let endTime = endTime {
            let diff = endTime.timeIntervalSinceNow
            #expect(diff > 4 * 60 && diff <= 5 * 60)
        }

        // 2. 삭제
        storage.delete()
        let afterDelete = storage.getEndTime()
        #expect(afterDelete == nil)
    }

    @Test
    func breakTimeStorage_expiredTime_returnsNil() {
        let testSuiteName = "test.group.yapp.breake.brake"
        var storage = BreakTimeStorage()
        storage.userDefaults = UserDefaults(suiteName: testSuiteName)
        storage.delete()

        // 더 과거 시간 저장 (예: -1시간)
        let calendar = Calendar.current
        let pastDate = calendar.date(byAdding: .hour, value: -1, to: Date())!
        storage.userDefaults?.set(pastDate, forKey: "breakEndTime")

        // 만료된 시간은 nil 반환 + 자동 삭제
        let result = storage.getEndTime()
        #expect(result == nil)
        let stillExists = storage.userDefaults?.object(forKey: "breakEndTime")
        #expect(stillExists == nil)
    }
}
