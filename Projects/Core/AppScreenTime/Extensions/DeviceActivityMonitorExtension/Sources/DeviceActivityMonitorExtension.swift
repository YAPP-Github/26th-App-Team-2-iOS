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
    private let cooldownStorage: CooldownStorageProtocol = CooldownStorage()
    private let blockScheduleManager = BlockScheduleManager()
    private let managedSettingsManager = ManagedSettingsStoreManager()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        setupStartAction(by: activity)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        setupEndAction(by: activity)
    }

    private func setupStartAction(by activity: DeviceActivityName) {
        if activity == .longBrake {
            let extensionCount = appScheduleStorage.getExtensionCount()
            let userBrakeTime: Double = appScheduleStorage.getBreakEndDate().timeIntervalSince1970 - appScheduleStorage.getBreakStartDate().timeIntervalSince1970
            let extensionStartDate = Date.now.addingTimeInterval(userBrakeTime)
            let extensionEndDate = extensionStartDate.addingTimeInterval(15 * 60)

            appScheduleStorage.saveBlockingStatus(
                .extensionPrompt(
                    tokenName: "",
                    time: 15,
                    count: extensionCount,
                    startDate: extensionStartDate,
                    endDate: extensionEndDate
                )
            )

            appScheduleStorage.saveSelectNotificationTrigger(false)

            // 저장된 모든 스케줄을 가져와서 차단 해제
            let allSchedules = blockScheduleManager.readAll()
            managedSettingsManager.clearAllBlockListsForRest(schedules: allSchedules)
        } else if let schedule = BlockSchedule(from: activity) {
            // DeviceActivityName과 매칭되는 BlockSchedule의 블록리스트를 적용
            appScheduleStorage.saveSelectNotificationTrigger(true)
            blockScheduleManager.startBlockSchedule(schedule)
        } else {
            // BlockSchedule을 찾을 수 없는 경우에도 차단 상태를 활성화
            appScheduleStorage.saveBlockingStatus(.blocking(tokenName: ""))
        }
    }

    private func setupEndAction(by activity: DeviceActivityName) {
        if activity == .longBrake {
            // 휴식 시간 종료 - 차단 재설정 및 extensionPrompt 상태로 설정
            appScheduleStorage.saveSelectNotificationTrigger(false)

            // 저장된 모든 스케줄에 대해 차단 재설정
            let allSchedules = blockScheduleManager.readAll()
            allSchedules.forEach { schedule in
                blockScheduleManager.startBlockSchedule(schedule)
            }

            // extensionPrompt 상태로 설정
            let extensionCount = appScheduleStorage.getExtensionCount() // 현재 연장 횟수
            let maxExtensions = 1

            let extensionStartDate = Date.now
            let extensionEndDate = extensionStartDate.addingTimeInterval(15 * 60)

            // 연장 횟수가 0이면 최초 휴식 종료이므로 extensionPrompt(0/2)로 설정
            if extensionCount == 0 {
                appScheduleStorage.saveBlockingStatus(
                    .extensionPrompt(
                        tokenName: "",
                        time: 15,
                        count: 0,
                        startDate: extensionStartDate,
                        endDate: extensionEndDate
                    )
                )
            } else if extensionCount < maxExtensions {
                // 연장 가능: extensionPrompt 상태로 설정
                appScheduleStorage.saveBlockingStatus(
                    .extensionPrompt(
                        tokenName: "",
                        time: 15,
                        count: extensionCount,
                        startDate: extensionStartDate,
                        endDate: extensionEndDate
                    )
                )
            } else {
                // 연장 불가: sessionEnded 상태로 설정 (5번 화면)
                appScheduleStorage.saveBlockingStatus(
                    .cooldownActive(
                        tokenName: "앱 그룹",
                        time: 15,
                        groupName: "앱 그룹",
                        startDate: .now,
                        endDate: .now.addingTimeInterval(15 * 60)
                    )
                )
            }
        } else if let schedule = BlockSchedule(from: activity)  {
            // 스케줄 종료 시 차단 상태 설정
            blockScheduleManager.endBlockSchedule(schedule)
        } else {
            // BlockSchedule을 찾을 수 없는 경우에도 차단 상태를 해제
            managedSettingsManager.clearAllBlockListsForRest(schedules: [])
        }
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
