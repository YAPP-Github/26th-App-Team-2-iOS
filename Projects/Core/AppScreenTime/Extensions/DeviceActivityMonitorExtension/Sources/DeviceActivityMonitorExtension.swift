//
//  DeviceActivityMonitorExtension.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/11/25.
//

import DeviceActivity
import Foundation
import ManagedSettings
import CoreAppScreenTimeInterface
import CoreAppScreenTime
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
        print("DeviceActivityMonitor: intervalDidStart for \(activity.rawValue)")

        // Handle the start of the interval.
        // 세션 시작 시 앱 차단 시작
        if activity == .daily {
            Task {
                do {
                    // AppScheduleStorage를 통해 차단 상태 저장
                    appScheduleStorage.saveLastBlockTime(Date())

                    print("Starting daily monitoring")
                } catch {
                    print("Failed to start daily monitoring: \(error)")
                }
            }
        }
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        print("DeviceActivityMonitor: intervalDidEnd for \(activity.rawValue)")

        // Handle the end of the interval.
        // 세션 종료 시 앱 차단 해제
        if activity == .daily {
            Task {
                do {
                    // AppScheduleStorage를 통해 차단 상태 해제
                    appScheduleStorage.saveBlockingStatus(false)
                    
                    print("Ending daily monitoring")
                } catch {
                    print("Failed to end daily monitoring: \(error)")
                }
            }
        }
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        print("DeviceActivityMonitor: eventDidReachThreshold for \(event.rawValue) in \(activity.rawValue)")

        // Handle the event reaching its threshold.
        // 이벤트 임계값에 도달했을 때의 처리
    }

    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        print("DeviceActivityMonitor: intervalWillStartWarning for \(activity.rawValue)")

        // Handle the warning before the interval starts.
        // 세션 시작 전 경고 처리
    }

    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        print("DeviceActivityMonitor: intervalWillEndWarning for \(activity.rawValue)")

        // Handle the warning before the interval ends.
        // 세션 종료 전 경고 처리
    }

    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        print("DeviceActivityMonitor: eventWillReachThresholdWarning for \(event.rawValue) in \(activity.rawValue)")

        // Handle the warning before the event reaches its threshold.
        // 이벤트 임계값 도달 전 경고 처리
    }

    private func extractSessionKey(from activity: DeviceActivityName) -> String? {
        // DeviceActivityName에서 세션 키를 추출하는 로직
        // 실제 구현에서는 activity.rawValue를 파싱하여 세션 정보를 추출
        return activity.rawValue
    }
} 
