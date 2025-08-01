//
//  CreateBlockAppUseCase.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import Core
import DomainScreenTimeManagementInterface

/// 개별 앱 차단을 생성하는 UseCase
/// - 사용처: ContentView에서 특정 앱을 차단할 때
/// - 기능: 단일 앱에 대한 차단 스케줄을 생성하여 ScreenTime 제한을 설정
public struct CreateBlockAppUseCase: CreateBlockAppUseCaseProtocol {

    private let blockScheduleManager: BlockScheduleProtocol

    public init(blockScheduleManager: BlockScheduleProtocol) {
        self.blockScheduleManager = blockScheduleManager
    }

    public func execute(schedule: BlockScheduleEntity) throws {
        do {
            try blockScheduleManager.create(schedule.toRequest())
        } catch {
            throw ScreenTimeError.breakTimeCreationFailed(underlying: error)
        }
    }
}
