//
//  DeviceActivityMonitorExtension.swift
//  Brake
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

class DeviceActivityMonitorExtension: DeviceActivityMonitor {

    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
    private let blockScheduleManager = BlockScheduleManager()
    private let managedSettingsManager = ManagedSettingsStoreManager()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)

        if activity == .brake {
            // 휴식 시간 시작 - 모든 차단 해제
            appScheduleStorage.saveBlockingStatus(false)
            appScheduleStorage.saveSelectNotificationTrigger(true)

            // 저장된 모든 스케줄을 가져와서 차단 해제
            let allSchedules = blockScheduleManager.readAll()
            managedSettingsManager.clearAllBlockListsForRest(schedules: allSchedules)
            return
        }

        // DeviceActivityName과 매칭되는 BlockSchedule의 블록리스트를 적용
        guard let schedule = BlockSchedule(from: activity) else {
            // BlockSchedule을 찾을 수 없는 경우에도 차단 상태를 활성화
            appScheduleStorage.saveBlockingStatus(true)
            return
        }
        appScheduleStorage.saveSelectNotificationTrigger(true)
        blockScheduleManager.startBlockSchedule(schedule)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        if activity == .brake {
            // 휴식 시간 종료 - 차단 재설정
            appScheduleStorage.saveBlockingStatus(true)
            appScheduleStorage.saveSelectNotificationTrigger(true)

            // 저장된 모든 스케줄에 대해 차단 재설정
            let allSchedules = blockScheduleManager.readAll()
            allSchedules.forEach { schedule in
                blockScheduleManager.startBlockSchedule(schedule)
            }
            return
        }

        guard let schedule = BlockSchedule(from: activity) else {
            // BlockSchedule을 찾을 수 없는 경우에도 차단 상태를 해제
            appScheduleStorage.saveBlockingStatus(false)
            // 모든 Shield 설정을 강제로 해제
            managedSettingsManager.clearAllBlockListsForRest(schedules: [])
            return
        }
        blockScheduleManager.endBlockSchedule(schedule)
    }
}

// BlockSchedule extension for DeviceActivityName conversion
private extension BlockSchedule {
    init?(from deviceActivityName: DeviceActivityName) {
        // DeviceActivityName.rawValue가 BlockSchedule의 id와 매칭되는지 확인
        // 실제 구현에서는 저장된 BlockSchedule에서 찾기
        guard let schedule = BlockScheduleManager().read(deviceActivityName.rawValue) else {
            return nil
        }

        self = schedule
    }
}
