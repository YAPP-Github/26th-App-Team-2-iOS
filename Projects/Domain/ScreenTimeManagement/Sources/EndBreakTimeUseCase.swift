//
//  EndBreakTimeUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

public struct EndBreakTimeUseCase: EndBreakTimeUseCaseProtocol {
    
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
            appScheduleStorage.saveBlockingStatus(.extensionPrompt(time: 15, count: 0))
        } else if extensionCount < maxExtensions {
            // 연장 가능: extensionPrompt 상태로 설정
            appScheduleStorage.saveBlockingStatus(.extensionPrompt(time: 15, count: extensionCount))
        } else {
            // 연장 불가: sessionEnded 상태로 설정
            appScheduleStorage.saveBlockingStatus(.sessionEnded(time: 15, groupName: "앱 그룹"))
        }
    }
} 
