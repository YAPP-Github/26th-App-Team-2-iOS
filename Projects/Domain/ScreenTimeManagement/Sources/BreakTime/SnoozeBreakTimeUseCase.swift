//
//  SnoozeBreakTimeUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 휴식 시간을 스누즈(일시 중지)하는 UseCase
/// - 사용처: DeviceActivityMonitorExtension에서 휴식 시간이 시작될 때
/// - 기능: 15분간의 스누즈 시간을 설정하고, 모든 앱 차단을 일시적으로 해제
public struct SnoozeBreakTimeUseCase: SnoozeBreakTimeUseCaseProtocol {
    
    private let appScheduleStorage: AppScheduleStorageProtocol
    private let blockScheduleManager: BlockScheduleProtocol
    private let managedSettingsManager: ManagedSettingsStoreProtocol

    public init(
        appScheduleStorage: AppScheduleStorageProtocol,
        blockScheduleManager: BlockScheduleProtocol,
        managedSettingsManager: ManagedSettingsStoreProtocol
    ) {
        self.appScheduleStorage = appScheduleStorage
        self.blockScheduleManager = blockScheduleManager
        self.managedSettingsManager = managedSettingsManager
    }
    
    public func execute() throws {
        // 1. extensionPrompt 상태로 설정
        let extensionCount = appScheduleStorage.getExtensionCount()
        let userBrakeTime: Double = appScheduleStorage.getBreakEndDate().timeIntervalSince1970 - appScheduleStorage.getBreakStartDate().timeIntervalSince1970
        let extensionStartDate = Date.now.addingTimeInterval(userBrakeTime)
        let extensionEndDate = extensionStartDate.addingTimeInterval(15 * 60)
        appScheduleStorage.saveBlockingStatus(.extensionPrompt(tokenName: "", time: 15, count: extensionCount, startDate: extensionStartDate, endDate: extensionEndDate))

        // 2. 알림 트리거 비활성화
        appScheduleStorage.saveSelectNotificationTrigger(false)
        
        // 3. 저장된 모든 스케줄을 가져와서 차단 해제
        let allSchedules = blockScheduleManager.readAll()
        managedSettingsManager.clearAllBlockListsForRest(schedules: allSchedules)
    }
} 

