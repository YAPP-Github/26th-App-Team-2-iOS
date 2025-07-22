//
//  AppScheduleStorageProtocol.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 7/11/25.
//

import Foundation
import ManagedSettings

public protocol AppScheduleStorageProtocol {
    func saveSelectedApps(_ tokens: [Application])
    func getSelectedApps() -> [Application]
    func saveBlockingStatus(_ isBlocked: Bool)
    func getBlockingStatus() -> Bool
    func saveLastBlockTime(_ date: Date)
    func getLastBlockTime() -> Date?
    func clearAllData()
}
