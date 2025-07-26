//
//  DeviceActivityName.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import DeviceActivity
import CoreAppScreenTimeInterface

extension DeviceActivityName {
    public static let brake = Self("brake")
    public init(from model: BlockSchedule) {
        self = .init(model.id)
    }
}
