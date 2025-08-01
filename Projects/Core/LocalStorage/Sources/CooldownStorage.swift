//
//  CooldownStorage.swift
//  CoreLocalStorage
//
//  Created by Derrick kim on 2025/01/27.
//

import Foundation
import CoreLocalStorageInterface

public struct CooldownStorage: CooldownStorageProtocol {
    
    private let userDefaults: UserDefaults?
    
    public init() {
        // App Group을 사용하여 Extension과 데이터 공유
        let appGroupName = Bundle.main.appGroupName
        self.userDefaults = UserDefaults(suiteName: appGroupName)
    }
    
    // MARK: - Keys
    
    private enum Keys {
        static let cooldownEndTime = "cooldown_end_time"
        static let cooldownGroup = "cooldown_group"
    }
    
    // MARK: - CooldownStorageProtocol
    
    public func startCooldown(minutes: Int) {
        guard isEmpty else { return }
        let cooldownEndTime = Date().addingTimeInterval(TimeInterval(minutes * 60))
        userDefaults?.set(cooldownEndTime, forKey: Keys.cooldownEndTime)
    }
    
    public func getCooldownEndTime() -> Date? {
        return userDefaults?.object(forKey: Keys.cooldownEndTime) as? Date
    }
    
    public func isInCooldown() -> Bool {
        guard let cooldownEndTime = getCooldownEndTime() else {
            return false
        }
        return Date() < cooldownEndTime
    }
    
    public func getRemainingCooldownTime() -> TimeInterval {
        guard let cooldownEndTime = getCooldownEndTime() else {
            return 0
        }
        return max(0, cooldownEndTime.timeIntervalSince(Date()))
    }
    
    public func endCooldown() {
        userDefaults?.removeObject(forKey: Keys.cooldownEndTime)
        userDefaults?.removeObject(forKey: Keys.cooldownGroup)
    }
    
    public func saveCooldownGroup(groupName: String) {
        userDefaults?.set(groupName, forKey: Keys.cooldownGroup)
    }
    
    public func getCooldownGroup() -> String? {
        return userDefaults?.string(forKey: Keys.cooldownGroup)
    }
    
    public func clearCooldownData() {
        userDefaults?.removeObject(forKey: Keys.cooldownEndTime)
        userDefaults?.removeObject(forKey: Keys.cooldownGroup)
    }

    private var isEmpty: Bool {
        return getCooldownEndTime() == nil
    }
}
