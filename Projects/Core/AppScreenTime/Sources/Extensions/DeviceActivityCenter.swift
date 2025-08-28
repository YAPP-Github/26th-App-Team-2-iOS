//
//  DeviceActivityCenter.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation
import DeviceActivity
import CoreAppScreenTimeInterface

extension DeviceActivityCenter {
    // start 모니터링 시작
    public func startMonitoring(_ model: BlockSchedule) throws {
        let scheduleName = DeviceActivityName(from: model)
        let start = DateComponents(
            hour: model.startTime.hour,
            minute: model.startTime.minute
        )
        let end = DateComponents(
            hour: model.endTime.hour,
            minute: model.endTime.minute
        )
        let schedule = DeviceActivitySchedule(
            intervalStart: start,
            intervalEnd: end,
            repeats: true
        )
        try setMonitoring(scheduleName, during: schedule)
    }

    // 휴식 스케줄 등록
    func createBrakeTime(_ schedule: DeviceActivitySchedule) throws {
        try setMonitoring(.brake, during: schedule)
    }

    // 휴식 스케줄 종료
    func stopBrakeTime() {
        stopMonitoring([.brake])
    }

    // 휴식 스케줄 등록
    private func setMonitoring(_ name: DeviceActivityName, during schedule: DeviceActivitySchedule) throws {
        do {
            try startMonitoring(
                name,
                during: schedule
            )
        } catch {
            throw error
        }
    }
}

extension DeviceActivitySchedule {
    static func makeSchedule(intervalStart: Date, intervalEnd: Date) -> DeviceActivitySchedule {
        let dateComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second,
            .nanosecond
        ]
        
        let interval = intervalEnd.timeIntervalSince1970 - intervalStart.timeIntervalSince1970
        print("인터벌 시간", interval)
        if interval < 15 * 60 {
            let startTime = Calendar.current.dateComponents(dateComponents, from: intervalStart)
            let minimumEnd = intervalStart.addingTimeInterval(15 * 60)
            let endTime = Calendar.current.dateComponents(dateComponents, from: minimumEnd)
            let warning = minimumEnd.timeIntervalSince1970 - intervalEnd.timeIntervalSince1970
            let warningTime = Calendar.current.dateComponents(dateComponents, from: minimumEnd.addingTimeInterval(-warning))
            print("startTime: \(startTime)")
            print("endTime: \(endTime)")
            print("warningTime: \(warningTime)")

            return DeviceActivitySchedule(
                intervalStart: startTime,
                intervalEnd: endTime,
                repeats: false,
                // intervalEnd 전에 경고를 준다.
                warningTime: warningTime
            )
        } else {
            let startTime = Calendar.current.dateComponents(dateComponents, from: intervalStart)
            let endTime = Calendar.current.dateComponents(dateComponents, from: intervalEnd)
            return DeviceActivitySchedule(
                intervalStart: startTime,
                intervalEnd: endTime,
                repeats: false
            )
        }
    }
}
