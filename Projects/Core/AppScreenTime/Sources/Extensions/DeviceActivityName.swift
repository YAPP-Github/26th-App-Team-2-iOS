//
//  DeviceActivityName.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import DeviceActivity
import CoreAppScreenTimeInterface

extension DeviceActivityName {
    public static let daily = Self("daily")

    public init(from model: BlockSchedule) {
        self = .init(model.id)
    }
}
