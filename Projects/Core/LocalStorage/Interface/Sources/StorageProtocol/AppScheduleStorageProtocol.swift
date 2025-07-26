//
//  AppScheduleStorageProtocol.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 7/11/25.
//

import Foundation
import ManagedSettings
import FamilyControls

public protocol AppScheduleStorageProtocol {
    func saveSelectNotificationTrigger(_ isSelected: Bool)
    func getSelectedNotification() -> Bool
    func saveBlockingStatus(_ isBlocked: Bool)
    func getBlockingStatus() -> Bool
    func saveLastBlockTime(_ date: Date)
    func getLastBlockTime() -> Date?
    func clearAllData()

    // BlockSchedule 저장/로드 메서드들 (Data 기반으로 변경)
    func saveBlockScheduleData(_ data: Data, forId id: String)
    func getBlockScheduleData(forId id: String) -> Data?
    func getAllBlockScheduleIds() -> [String]
    func deleteBlockSchedule(id: String)
    func clearAllBlockSchedules()
}
