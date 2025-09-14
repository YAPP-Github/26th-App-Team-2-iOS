//
//  CreateBreakTimeUseCase.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

/// 휴식 시간을 생성하는 UseCase
/// - 사용처: ContentView에서 사용자가 휴식 시간을 설정할 때
/// - 기능: 지정된 시간(분) 동안의 휴식 시간을 생성하고 관련 상태를 초기화
public struct CreateBreakTimeUseCase: CreateBreakTimeUseCaseProtocol {

    private let breakTimeManager: BreakTimeProtocol
    private let appScheduleStorage: AppScheduleStorageProtocol

    public init(
        breakTimeManager: BreakTimeProtocol,
        appScheduleStorage: AppScheduleStorageProtocol
    ) {
        self.breakTimeManager = breakTimeManager
        self.appScheduleStorage = appScheduleStorage
    }

    public func execute(by minutes: Int) async throws {
        // 입력 검증 - 최소 15분
        guard minutes >= 1 else {
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
