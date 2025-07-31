//
//  StartBlockScheduleUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

public struct StartBlockScheduleUseCase: StartBlockScheduleUseCaseProtocol {

    private let appScheduleStorage: AppScheduleStorageProtocol
    private let blockScheduleManager: BlockScheduleProtocol

    public init(
        appScheduleStorage: AppScheduleStorageProtocol,
        blockScheduleManager: BlockScheduleProtocol
    ) {
        self.appScheduleStorage = appScheduleStorage
        self.blockScheduleManager = blockScheduleManager
    }

    public func execute(schedule: BlockScheduleEntity) throws {
        // 1. 알림 트리거 활성화
        appScheduleStorage.saveSelectNotificationTrigger(true)

        // 2. 차단 스케줄 시작
        blockScheduleManager.startBlockSchedule(schedule.toRequest())
    }
}
