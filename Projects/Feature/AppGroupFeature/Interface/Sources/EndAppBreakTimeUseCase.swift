//
//  EndBrakeTimeUseCase.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 8/6/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 휴식 시간을 종료하는 UseCase
/// - 사용처: App에서 휴식 시간이 종료될 때
/// - 기능: 휴식 시간 종료 시, 즉시 쿨다운으로 설정
public struct EndAppBreakTimeUseCase: EndBreakTimeUseCaseProtocol {
    
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
        
        // 연장 불가: sessionEnded 상태로 설정
        // 15분만 더 sessionEnded 상태로 변경
        let cooldownMinutes = appScheduleStorage.getExtensionTime() // 저장된 연장 시간 사용
        handleExtensionTimeExhausted(groupName: "앱 그룹", cooldownMinutes: cooldownMinutes)
        
    }
    
    /// 연장 시간이 모두 사용된 경우 호출
    private func handleExtensionTimeExhausted(groupName: String, cooldownMinutes: Int) {
        print("Session Ended는 잘 될까?")
        let startDate = Date.now
        let endDate = startDate.addingTimeInterval(TimeInterval(cooldownMinutes * 60))

        let status = BlockingStatus
            .cooldownActive(
                tokenName: "",
                time: cooldownMinutes,
                groupName: groupName,
                startDate: startDate,
                endDate: endDate
            )
        appScheduleStorage.saveBlockingStatus(status)

        // 쿨다운 시작
        
        cooldownStorage.saveCooldownGroup(groupName: groupName)
        cooldownStorage.startCooldown(minutes: cooldownMinutes)
    }
}
