//
//  DeviceActivityMonitorExtension.swift
//  Brake
//
//  Created by Derrick kim on 7/11/25.
//

import DeviceActivity
import Foundation
import ManagedSettings
import CoreLocalStorageInterface
import CoreLocalStorage

// DeviceActivityName extension을 import
extension DeviceActivityName {
    static let daily = Self("daily")
}

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)

        // Handle the start of the interval.
        // 세션 시작 시 앱 차단 시작
        if activity == .daily {
            // AppScheduleStorage를 통해 차단 상태 저장
            appScheduleStorage.saveBlockingStatus(true)
            appScheduleStorage.saveLastBlockTime(Date())
        }
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        // Handle the end of the interval.
        // 세션 종료 시 앱 차단 해제
        if activity == .daily {
            // AppScheduleStorage를 통해 차단 상태 해제
            appScheduleStorage.saveBlockingStatus(false)
        }
    }

    private func extractSessionKey(from activity: DeviceActivityName) -> String? {
        // DeviceActivityName에서 세션 키를 추출하는 로직
        // 실제 구현에서는 activity.rawValue를 파싱하여 세션 정보를 추출
        return activity.rawValue
    }
} 
