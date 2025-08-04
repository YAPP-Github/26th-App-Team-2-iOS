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
    func saveAppName(_ name: String)
    func getAppName() -> String?
    func saveSelectNotificationTrigger(_ isSelected: Bool)
    func getSelectedNotification() -> Bool
    func saveBlockingStatus(_ status: BlockingStatus)
    func getBlockingStatus() -> BlockingStatus?
    func saveExtensionCount(_ count: Int)
    func getExtensionCount() -> Int
    
    // 연장 시간 관련 메서드들
    func saveExtensionTime(_ minutes: Int)
    func getExtensionTime() -> Int

    // BlockSchedule 저장/로드 메서드들 (Data 기반으로 변경)
    func saveBlockScheduleData(_ data: Data, forId id: String)
    func getBlockScheduleData(forId id: String) -> Data?
    func getAllBlockScheduleIds() -> [String]
    func deleteBlockSchedule(id: String)
    
    
    func getBreakStartDate() -> Date
    func setBreakStartDate(date: Date)
    
    func getBreakEndDate() -> Date
    func setBreakEndDate(date: Date)
}
