//
//  BreakTimeManager.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation
import DeviceActivity
import CoreAppScreenTimeInterface

// 휴식 시간 관리자
public struct BreakTimeManager: BreakTimeProtocol {

    private let center = DeviceActivityCenter()

    public init() { }

    // 휴식 스케줄 추가
    public func createBreakTime(endDate: Date?) throws {
        let dateComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second,
            .nanosecond
        ]

        let startTime = Calendar.current.dateComponents(dateComponents, from: .now.addingTimeInterval(-900))
        let endTime = Calendar.current.dateComponents(dateComponents, from: endDate ?? Date())

        let breakSchedule = DeviceActivitySchedule(
            intervalStart: startTime,
            intervalEnd: endTime,
            repeats: false
        )

        try center.createBreakTime(breakSchedule)
    }
    
    // 휴식 스케줄 삭제
    public func deleteBreakTime() {
        center.stopMonitoring([DeviceActivityName.daily])
    }
}
