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
    private let userDefaults: UserDefaults?
    
    public init() {
        let appGroupName = Bundle.main.appGroupName
        self.userDefaults = UserDefaults(suiteName: appGroupName)
    }
    
    private enum Keys {
        static let appName = "appName"
        static let isSelectedNotification = "isSelectedNotification"
        static let blockingStatus = "blockingStatus"
        static let allBlockScheduleIds = "allBlockScheduleIds"
        static let extensionCount = "extensionCount"
        static let extensionTime = "extensionTime"
        static let extensionGroupName = "extensionGroupName"
        
        static let startBrakeDate = "startBrakeDate"
        static let endBrakeDate = "endBrakeDate"

        static func blockSchedule(id: String) -> String {
            return "blockSchedule_\(id)"
        }
    }

    public func saveAppName(_ name: String) {
        userDefaults?.set(name, forKey: Keys.appName)
    }

    public func getAppName() -> String? {
        return userDefaults?.string(forKey: Keys.appName)
    }

    public func saveSelectNotificationTrigger(_ isSelected: Bool) {
        userDefaults?.set(isSelected, forKey: Keys.isSelectedNotification)
    }

    public func getSelectedNotification() -> Bool {
        return userDefaults?.bool(forKey: Keys.isSelectedNotification) ?? false
    }

    public func saveBlockingStatus(_ status: BlockingStatus) {
        do {
            let data = try JSONEncoder().encode(status)
            userDefaults?.set(data, forKey: Keys.blockingStatus)
        } catch {
            // 에러 발생 시 기본 blocking 상태로 fallback
            userDefaults?.removeObject(forKey: Keys.blockingStatus)
        }
    }

    public func getBlockingStatus() -> BlockingStatus? {
        guard let data = userDefaults?.data(forKey: Keys.blockingStatus) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(BlockingStatus.self, from: data)
        } catch {
            // 에러 발생 시 저장된 데이터 삭제
            userDefaults?.removeObject(forKey: Keys.blockingStatus)
            return nil
        }
    }

    // MARK: - BlockSchedule 저장/로드 (Data 기반)
    
    public func saveBlockScheduleData(_ data: Data, forId id: String) {
        userDefaults?.set(data, forKey: Keys.blockSchedule(id: id))
        
        // 모든 BlockSchedule ID 목록도 저장
        var allIds = getAllBlockScheduleIds()
        if !allIds.contains(id) {
            allIds.append(id)
            userDefaults?.set(allIds, forKey: Keys.allBlockScheduleIds)
        }
    }
    
    public func getBlockScheduleData(forId id: String) -> Data? {
        return userDefaults?.data(forKey: Keys.blockSchedule(id: id))
    }
    
    public func getAllBlockScheduleIds() -> [String] {
        return userDefaults?.array(forKey: Keys.allBlockScheduleIds) as? [String] ?? []
    }
    
    public func deleteBlockSchedule(id: String) {
        userDefaults?.removeObject(forKey: Keys.blockSchedule(id: id))
        
        // ID 목록에서도 제거
        var allIds = getAllBlockScheduleIds()
        allIds.removeAll { $0 == id }
        userDefaults?.set(allIds, forKey: Keys.allBlockScheduleIds)
    }

    public func saveExtensionCount(_ count: Int) {
        userDefaults?.set(count, forKey: Keys.extensionCount)
    }

    public func getExtensionCount() -> Int {
        return userDefaults?.integer(forKey: Keys.extensionCount) ?? 0
    }
    
    
    // MARK: - 연장 시간 관련 메서드들
    
    public func saveExtensionTime(_ minutes: Int) {
        userDefaults?.set(minutes, forKey: Keys.extensionTime)
    }
    
    public func getExtensionTime() -> Int {
        return userDefaults?.integer(forKey: Keys.extensionTime) ?? 15 // 기본값 15분
    }
    
    // MARK: -- 타이머 시간 관련 메서드들
    
    public func getBreakStartDate() -> Date {
        let dateInterval = userDefaults?.double(forKey: Keys.startBrakeDate) ?? 0
        return Date(timeIntervalSince1970:  dateInterval)
    }
    public func setBreakStartDate(date: Date) {
        let startInterval = date.timeIntervalSince1970
        userDefaults?.set(startInterval, forKey: Keys.startBrakeDate)
    }
    
    public func getBreakEndDate() -> Date {
        let dateInterval = userDefaults?.double(forKey: Keys.endBrakeDate) ?? 0
        return Date(timeIntervalSince1970: dateInterval)
    }
    
    public func setBreakEndDate(date: Date) {
        let endInterval = date.timeIntervalSince1970
        userDefaults?.set(endInterval, forKey: Keys.endBrakeDate)
    }
}
