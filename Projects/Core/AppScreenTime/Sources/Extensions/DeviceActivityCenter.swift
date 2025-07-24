//
//  DeviceActivityCenter.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation
import DeviceActivity
import CoreAppScreenTimeInterface

public extension DeviceActivityCenter {
    // star 모니터링 시작
    func startMonitoring(_ model: BlockSchedule) throws {
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

        do {
            try startMonitoring(
                scheduleName,
                during: schedule
            )
        } catch {
            throw DeviceActivityCenterError.monitoringFailed
        }
    }
    // 휴식 스케줄 등록
    func createBreakTime(_ schedule: DeviceActivitySchedule) throws {
        do {
            try startMonitoring(
                DeviceActivityName.daily,
                during: schedule
            )
        } catch {
            throw DeviceActivityCenterError.createScheduleFailed
        }
    }
}
