//
//  StartBlockScheduleUseCase.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 앱 차단 스케줄을 시작하는 UseCase
/// - 사용처: ContentView에서 앱 차단을 시작할 때
/// - 기능: 차단 스케줄을 시작하고 알림 트리거를 활성화하여 사용자에게 차단 알림을 제공
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
