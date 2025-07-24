//
//  CalculatedBlockSchedule.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation

public struct CalculatedBlockSchedule {
    public var currentStatus: BlockState.Status
    public var remainingTime: TimeInterval

    public init(currentStatus: BlockState.Status, remainingTime: TimeInterval) {
        self.currentStatus = currentStatus
        self.remainingTime = remainingTime
    }
}
