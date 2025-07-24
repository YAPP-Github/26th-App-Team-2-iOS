//
//  File.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import CoreAppScreenTimeInterface
import Foundation

public extension BlockSchedule {
    func starTimeDateComponents() -> DateComponents {
        return DateComponents(
            hour: startTime.hour,
            minute: startTime.minute
        )
    }

    func finishTimeDateComponents() -> DateComponents {
        return DateComponents(
            hour: endTime.hour,
            minute: endTime.minute
        )
    }

    func state(schedule: CalculatedBlockSchedule) -> BlockState {
        return BlockState(
            status: schedule.currentStatus,
            remainingTime: schedule.remainingTime
        )
    }
}
