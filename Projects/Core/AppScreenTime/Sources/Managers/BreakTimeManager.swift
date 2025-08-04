//
//  BreakTimeManager.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation
import DeviceActivity
import CoreAppScreenTimeInterface
import CoreLocalStorage
import CoreLocalStorageInterface

// 휴식 시간 관리자
public struct BreakTimeManager: BreakTimeProtocol {
    

    private let center = DeviceActivityCenter()
    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
    
    public init() { }

    // 휴식 스케줄 추가 (분 단위로 받음)
    public func createBreakTime(minutes: Int) throws {
        // 최소 15분 이상 필요
        guard minutes >= 15 else {
            throw DeviceActivityCenterError.intervalTooShort
        }
        
        let dateComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second,
            .nanosecond
        ]
        
        // 현재 시간부터 시작
        let startDate: Date = Date()
        appScheduleStorage.setBreakStartDate(date: startDate)
        let startTime = Calendar.current.dateComponents(dateComponents, from: .now)

        // 종료 시간 계산 (크로스데이 허용)
        let endDate: Date = Calendar.current.date(byAdding: .minute, value: minutes, to: .now) ?? .now
        appScheduleStorage.setBreakEndDate(date: endDate)
        let endTime = Calendar.current.dateComponents(dateComponents, from: endDate)
        let breakSchedule = DeviceActivitySchedule(
            intervalStart: startTime,
            intervalEnd: endTime,
            repeats: false
        )

        try center.createBrakeTime(breakSchedule)
    }
    
    // 휴식 스케줄 삭제
    public func deleteBreakTime() {
        center.stopBrakeTime()
    }
    
    public func getStartDate() -> Date {
        self.appScheduleStorage.getBreakStartDate()
    }
    public func getEndDate() -> Date {
        self.appScheduleStorage.getBreakEndDate()
    }
}
