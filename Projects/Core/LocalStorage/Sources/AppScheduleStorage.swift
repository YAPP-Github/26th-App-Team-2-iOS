//
//  AppScheduleStorage.swift
//  CoreLocalStorage
//
//  Created by Derrick kim on 7/11/25.
//

import Foundation
import ManagedSettings
import CoreLocalStorageInterface

public struct AppScheduleStorage: AppScheduleStorageProtocol {
    public var userDefaults: UserDefaults?

    public init() {
        guard let appGroupName = Bundle.main.object(forInfoDictionaryKey: "APP_GROUP_NAME") as? String else {
            return
        }
        self.userDefaults = UserDefaults(suiteName: appGroupName)
    }

    public func saveSelectedApps(_ tokens: [Application]) {
        // ApplicationToken을 Data로 변환하여 저장
        let tokenData = tokens.map { token in
            return [
                "tokenString": token.token.debugDescription,
                "localizedDisplayName": token.localizedDisplayName ?? "알 수 없는 앱"
            ]
        }
        userDefaults?.set(tokenData, forKey: "selectedApps")
    }

    public func getSelectedApps() -> [Application] {
        guard let tokenData = userDefaults?.array(forKey: "selectedApps") as? [[String: Any]] else {
            return []
        }

        return tokenData.compactMap { data in
            return nil
        }
    }

    public func saveBlockingStatus(_ isBlocked: Bool) {
        userDefaults?.set(isBlocked, forKey: "isBlocked")
    }

    public func getBlockingStatus() -> Bool {
        return userDefaults?.bool(forKey: "isBlocked") ?? false
    }

    public func saveLastBlockTime(_ date: Date) {
        userDefaults?.set(date.timeIntervalSince1970, forKey: "lastBlockTime")
    }

    public func getLastBlockTime() -> Date? {
        guard let timeInterval = userDefaults?.double(forKey: "lastBlockTime") else {
            return nil
        }
        return Date(timeIntervalSince1970: timeInterval)
    }

    public func clearAllData() {
        userDefaults?.removeObject(forKey: "selectedApps")
        userDefaults?.removeObject(forKey: "isBlocked")
        userDefaults?.removeObject(forKey: "lastBlockTime")
    }
}
