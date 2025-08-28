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
import OSLog

class DeviceActivityMonitorExtension: DeviceActivityMonitor {

    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
    private let cooldownStorage: CooldownStorageProtocol = CooldownStorage()
    private let blockScheduleManager = BlockScheduleManager()
    private let managedSettingsManager = ManagedSettingsStoreManager()
    
    private let coolDownMinutes: Int = 5
    private let logger = Logger(
        subsystem: "yapp.breake.Debug-AppGroupFeature.DeviceActivityMonitorExtension",
        category: "DeviceActivityTEST"
    )

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        logger.log("intervalDidStart")
        setupStartAction(by: activity)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        logger.log("intervalDidEnd")
        setupEndAction(by: activity)
    }

    private func setupStartAction(by activity: DeviceActivityName) {
        if activity == .brake {
            logger.log("setupStartAction activity")
            let extensionCount: Int = appScheduleStorage.getExtensionCount()
            let userBrakeTime: Double = appScheduleStorage.getBreakEndDate().timeIntervalSince1970 - appScheduleStorage.getBreakStartDate().timeIntervalSince1970
            let extensionStartDate = Date.now.addingTimeInterval(userBrakeTime)
            let extensionEndDate = extensionStartDate.addingTimeInterval(TimeInterval(coolDownMinutes * 60))
            
            appScheduleStorage.saveBlockingStatus(
                .extensionPrompt(
                    tokenName: "", time: 5,
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
            logger.log("setupStartAction schedule \(schedule.id) \(schedule.title)")
            // DeviceActivityName과 매칭되는 BlockSchedule의 블록리스트를 적용
            appScheduleStorage.saveSelectNotificationTrigger(true)
            blockScheduleManager.startBlockSchedule(schedule)
        } else {
            // BlockSchedule을 찾을 수 없는 경우에도 차단 상태를 활성화
            logger.log("other blocking")
            appScheduleStorage.saveBlockingStatus(.blocking(tokenName: ""))
        }
    }

    private func setupEndAction(by activity: DeviceActivityName) {
        if activity == .brake {
            logger.log("setupEndAction activity")
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
            let extensionEndDate = extensionStartDate.addingTimeInterval(TimeInterval(coolDownMinutes * 60))
            
            // 연장 횟수가 0이면 최초 휴식 종료이므로 extensionPrompt(0/2)로 설정
            if extensionCount == 0 {
                logger.log("setupEndAction activity - extensionCount 0")
                appScheduleStorage.saveBlockingStatus(
                    .extensionPrompt(
                        tokenName: "",
                        time: coolDownMinutes,
                        count: 0,
                        startDate: extensionStartDate,
                        endDate: extensionEndDate
                    )
                )
            } else if extensionCount < maxExtensions {
                // 연장 가능: extensionPrompt 상태로 설정
                appScheduleStorage.saveBlockingStatus(
                    .extensionPrompt(
                        tokenName: "", time: coolDownMinutes,
                        count: extensionCount,
                        startDate: extensionStartDate,
                        endDate: extensionEndDate
                    )
                )
            } else {
                // 연장 불가: sessionEnded 상태로 설정 (5번 화면)
                logger.log("setupEndAction activity - sessionEnded")
                appScheduleStorage.saveBlockingStatus(
                    .cooldownActive(
                        tokenName: "앱 그룹",
                        time: coolDownMinutes,
                        groupName: "앱 그룹",
                        startDate: .now,
                        endDate: .now.addingTimeInterval(TimeInterval(coolDownMinutes * 60))
                    )
                )
            }
        } else if let schedule = BlockSchedule(from: activity)  {
            // 스케줄 종료 시 차단 상태 설정
            logger.log("setupEndAction scedule")
            blockScheduleManager.endBlockSchedule(schedule)
        } else {
            // BlockSchedule을 찾을 수 없는 경우에도 차단 상태를 해제
            logger.log("block not found")
            managedSettingsManager.clearAllBlockListsForRest(schedules: [])
        }
    }
    // 5분 이내에 발생하는 Warning 값 대응... -> 타이머가 끝나기 전에 불리는 값이다!!
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        logger.log("intervalWillEndWarning \(activity.rawValue, privacy: .public)")
        if activity == .brake {
            let extensionCount = appScheduleStorage.getExtensionCount()
            let userBrakeTime: Double = appScheduleStorage.getBreakEndDate().timeIntervalSince1970 - appScheduleStorage.getBreakStartDate().timeIntervalSince1970
            logger.log("User Brake Time: \(userBrakeTime, privacy: .public)")
            let extensionStartDate = Date.now.addingTimeInterval(userBrakeTime)
            let extensionEndDate = extensionStartDate.addingTimeInterval(TimeInterval(coolDownMinutes * 60))
            logger.log("유저 연장시간 설정, \(extensionStartDate, privacy: .public), \(extensionEndDate, privacy: .public)")
            appScheduleStorage.saveBlockingStatus(
                .extensionPrompt(
                    tokenName: "",
                    time: coolDownMinutes,
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
            logger.log("스케쥴 찾기 - Blocking 하기")
            // DeviceActivityName과 매칭되는 BlockSchedule의 블록리스트를 적용
            appScheduleStorage.saveSelectNotificationTrigger(true)
            blockScheduleManager.startBlockSchedule(schedule)
        } else {
            // BlockSchedule을 찾을 수 없는 경우에도 차단 상태를 활성화
            appScheduleStorage.saveBlockingStatus(.blocking(tokenName: ""))
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


// 예약된 활동이 시작되고 종료되기 전에 앱 확장 프로그램에 미리 알려주는 경고 시간을 만들 수 있습니다. \
// 예를 들어 앱에서 임계값이 30분인 이벤트에 대해 오전 10시부터 오전 11시까지 활동 모니터링을 예약하는 경우, 일정의 경고 시간을 5분으로 설정하면 이벤트의 활동이 25분 동안 발생할 때 각각 오전 9시 55분, 오전 10시 55분 및 오전 9시에 intervalWillStartWarning(for:), intervalWillEndWarning(for:), eventWillReachThresholdWarning(_:activity:) 콜백이 확장 프로그램에 수신됩니다. 컴포넌트가 일정의 간격보다 더 긴 시간 간격을 지정하면 시스템은 각 이벤트의 임계값에 대한 경고 콜백을 간격의 시작 시간에 클램프합니다.
