//
//  AppGroupsStorageProtocol.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 7/11/25.
//

import Foundation
import ManagedSettings

public protocol AppGroupsStorageProtocol {
    func saveSelectedApps(_ tokens: [Application])
    func getSelectedApps() -> [Application]
    func saveBlockingStatus(_ isBlocked: Bool)
    func getBlockingStatus() -> Bool
    func saveLastBlockTime(_ date: Date)
    func getLastBlockTime() -> Date?
    func clearAllData()
}

public struct AppGroupsStorage {
    public var userDefaults: UserDefaults?

    public init() {
        guard let appGroupName = Bundle.main.object(forInfoDictionaryKey: "APP_GROUP_NAME") as? String else {
            return
        }
        self.userDefaults = UserDefaults(suiteName: appGroupName)
    }
}
