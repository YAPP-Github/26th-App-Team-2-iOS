//
//  EndBreakTimeUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 휴식 시간을 종료하는 UseCase
/// - 사용처: DeviceActivityMonitorExtension에서 휴식 시간이 종료될 때
/// - 기능: 휴식 시간 종료 시 앱 차단을 재설정하고, 연장 상태에 따라 적절한 차단 상태로 설정
public struct EndBreakTimeUseCase: EndBreakTimeUseCaseProtocol {
    
    private let appScheduleStorage: AppScheduleStorageProtocol
    private let blockScheduleManager: BlockScheduleProtocol
    private let managedSettingsManager: ManagedSettingsStoreProtocol
    private let cooldownStorage: CooldownStorageProtocol

    public init(
        appScheduleStorage: AppScheduleStorageProtocol,
        blockScheduleManager: BlockScheduleProtocol,
        managedSettingsManager: ManagedSettingsStoreProtocol,
        cooldownStorage: CooldownStorageProtocol
    ) {
        self.appScheduleStorage = appScheduleStorage
        self.blockScheduleManager = blockScheduleManager
        self.managedSettingsManager = managedSettingsManager
        self.cooldownStorage = cooldownStorage
    }
    
    public func execute() throws {
        // 1. 알림 트리거 비활성화
        appScheduleStorage.saveSelectNotificationTrigger(false)
        
        // 2. 저장된 모든 스케줄에 대해 차단 재설정
        let allSchedules = blockScheduleManager.readAll()
        allSchedules.forEach { schedule in
            blockScheduleManager.startBlockSchedule(schedule)
        }
        
        // 3. 연장 상태에 따른 차단 상태 설정
        let extensionCount = appScheduleStorage.getExtensionCount()
        let maxExtensions = 1
        
        if extensionCount == 0 {
            // 연장 횟수가 0이면 최초 휴식 종료이므로 extensionPrompt(0/2)로 설정
            appScheduleStorage.saveBlockingStatus(
                .extensionPrompt(
                    time: 15,
                    count: 0,
                    startDate: .now,
                    endDate: .now.addingTimeInterval(
                        15 * 60
                    )
                )
            )
        } else if extensionCount < maxExtensions {
            // 연장 가능: extensionPrompt 상태로 설정
            appScheduleStorage.saveBlockingStatus(
                .extensionPrompt(
                    time: 15,
                    count: extensionCount,
                    startDate: .now,
                    endDate: .now.addingTimeInterval(
                        15 * 60
                    )
                )
            )
        } else {
            // 연장 불가: sessionEnded 상태로 설정
            // 15분만 더 sessionEnded 상태로 변경
            let cooldownMinutes = appScheduleStorage.getExtensionTime() // 저장된 연장 시간 사용
            handleExtensionTimeExhausted(groupName: "앱 그룹", cooldownMinutes: 15)
//            appScheduleStorage.saveBlockingStatus(.sessionEnded(time: 15, groupName: "앱 그룹"))
        }
    }

    /// 연장 시간이 모두 사용된 경우 호출
    private func handleExtensionTimeExhausted(groupName: String, cooldownMinutes: Int) {
//        let status = BlockingStatus.sessionEnded(
//            time: cooldownMinutes,
//            groupName: groupName
//        )
//        
//        appScheduleStorage.saveBlockingStatus(status)
//
//        // 쿨다운 시작
//        cooldownStorage.saveCooldownGroup(groupName: groupName)
//        cooldownStorage.startCooldown(minutes: cooldownMinutes)
    }

}
