//
//  DeviceActivityCenterError.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation

public enum DeviceActivityCenterError: Error {
    case monitoringFailed
    case createScheduleFailed
    case intervalTooShort
}
