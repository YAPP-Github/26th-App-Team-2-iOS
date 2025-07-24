//
//  BlockScheduleCalculateManager.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import CoreAppScreenTimeInterface
import Foundation

public struct BlockScheduleCalculateManager: BlockScheduleCalculatorProtocol {
    public init() { }

    public func calculate(
        with startTime: BlockTime,
        and endTime: BlockTime
    ) -> CalculatedBlockSchedule {
        let currentStatus: BlockState.Status = (startTime <= BlockTime(date: .now) && BlockTime(date: .now) < endTime) ? .active : .rest
        let remainingTime: TimeInterval

        if currentStatus == .active {
            remainingTime = calculateTimeInterval(for: endTime)
        } else {
            remainingTime = calculateTimeInterval(for: startTime)
        }

        return CalculatedBlockSchedule(currentStatus: currentStatus, remainingTime: remainingTime)
    }

    private func calculateTimeInterval(for targetTime: BlockTime) -> TimeInterval {
        guard let targetDate = calculateDate(for: targetTime) else { return 0 }
        return targetDate.timeIntervalSince(.now)
    }

    private func calculateDate(for targetTime: BlockTime) -> Date? {
        let dateComponents = DateComponents(
            hour: targetTime.hour,
            minute: targetTime.minute
        )

        return Calendar.current.nextDate(
            after: .now,
            matching: dateComponents,
            matchingPolicy: .nextTime
        )
    }
}

