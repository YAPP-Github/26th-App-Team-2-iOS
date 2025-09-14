//
//  DeviceActivityName.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import DeviceActivity
import CoreAppScreenTimeInterface

extension DeviceActivityName {
    public static let longBrake = Self("longBrake")
    public static let shortBrake = Self("shortBrake")
    
    public init(from model: BlockSchedule) {
        self = .init(model.id)
    }
}
