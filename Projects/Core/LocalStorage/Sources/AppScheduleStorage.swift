//
//  AppScheduleStorage.swift
//  CoreLocalStorage
//
//  Created by Derrick kim on 7/11/25.
//

import Foundation
import ManagedSettings
import FamilyControls
import CoreLocalStorageInterface

public struct AppScheduleStorage: AppScheduleStorageProtocol {
    public let userDefaults: UserDefaults? = UserDefaults(suiteName: Bundle.main.appGroupName)

    public init() { }

    public func saveSelectNotificationTrigger(_ isSelected: Bool) {
        userDefaults?.set(isSelected, forKey: "isSelectedNotification")
    }

    public func getSelectedNotification() -> Bool {
        return userDefaults?.bool(forKey: "isSelectedNotification") ?? false
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
        userDefaults?.removeObject(forKey: "isBlocked")
        userDefaults?.removeObject(forKey: "lastBlockTime")
        clearAllBlockSchedules()
    }
    
    // MARK: - BlockSchedule 저장/로드 (Data 기반)
    
    public func saveBlockScheduleData(_ data: Data, forId id: String) {
        userDefaults?.set(data, forKey: "blockSchedule_\(id)")
        
        // 모든 BlockSchedule ID 목록도 저장
        var allIds = getAllBlockScheduleIds()
        if !allIds.contains(id) {
            allIds.append(id)
            userDefaults?.set(allIds, forKey: "allBlockScheduleIds")
        }
    }
    
    public func getBlockScheduleData(forId id: String) -> Data? {
        return userDefaults?.data(forKey: "blockSchedule_\(id)")
    }
    
    public func getAllBlockScheduleIds() -> [String] {
        return userDefaults?.array(forKey: "allBlockScheduleIds") as? [String] ?? []
    }
    
    public func deleteBlockSchedule(id: String) {
        userDefaults?.removeObject(forKey: "blockSchedule_\(id)")
        
        // ID 목록에서도 제거
        var allIds = getAllBlockScheduleIds()
        allIds.removeAll { $0 == id }
        userDefaults?.set(allIds, forKey: "allBlockScheduleIds")
    }
    
    public func clearAllBlockSchedules() {
        let allIds = getAllBlockScheduleIds()
        allIds.forEach { id in
            userDefaults?.removeObject(forKey: "blockSchedule_\(id)")
        }
        userDefaults?.removeObject(forKey: "allBlockScheduleIds")
    }
}
