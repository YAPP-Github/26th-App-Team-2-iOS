//
//  SnoozeBreakTimeUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

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
        appScheduleStorage.saveBlockingStatus(.extensionPrompt(time: 15, count: extensionCount))
        
        // 2. 알림 트리거 비활성화
        appScheduleStorage.saveSelectNotificationTrigger(false)
        
        // 3. 저장된 모든 스케줄을 가져와서 차단 해제
        let allSchedules = blockScheduleManager.readAll()
        managedSettingsManager.clearAllBlockListsForRest(schedules: allSchedules)
    }
} 
