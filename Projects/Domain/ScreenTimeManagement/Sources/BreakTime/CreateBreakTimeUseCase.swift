//
//  CreateBreakTimeUseCase.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

public struct CreateBreakTimeUseCase: CreateBreakTimeUseCaseProtocol {

    private let breakTimeManager: BreakTimeProtocol
    private let appScheduleStorage: AppScheduleStorageProtocol

    init(
        breakTimeManager: BreakTimeProtocol,
        appScheduleStorage: AppScheduleStorageProtocol
    ) {
        self.breakTimeManager = breakTimeManager
        self.appScheduleStorage = appScheduleStorage
    }

    public func execute(by minutes: Int) throws {
        // 입력 검증 - 최소 15분
        guard minutes >= 15 else {
            throw ScreenTimeError.invalidBreakTimeDuration(minutes: minutes)
        }

        do {
            try breakTimeManager.createBreakTime(minutes: minutes)
            appScheduleStorage.saveExtensionCount(0) // 초기화 필요
            appScheduleStorage.saveSelectNotificationTrigger(false)
        } catch {
            throw ScreenTimeError.breakTimeCreationFailed(underlying: error)
        }
    }
}
