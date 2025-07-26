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
    // star 모니터링 시작
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
