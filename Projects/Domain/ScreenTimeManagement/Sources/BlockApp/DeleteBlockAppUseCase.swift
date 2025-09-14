//
//  DeleteBlockAppUseCase.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import Core
import DomainScreenTimeManagementInterface

/// 개별 앱 차단을 삭제하는 UseCase
/// - 사용처: ContentView에서 특정 앱 차단을 해제할 때
/// - 기능: 단일 앱에 대한 차단 스케줄을 삭제하여 ScreenTime 제한을 해제
public struct DeleteBlockAppUseCase: DeleteBlockAppUseCaseProtocol {

    private let blockScheduleManager: BlockScheduleProtocol

    public init(blockScheduleManager: BlockScheduleProtocol) {
        self.blockScheduleManager = blockScheduleManager
    }

    public func execute(schedule: BlockScheduleEntity) throws {
//        blockScheduleManager.delete(name: <#DeviceActivityName#>, schedule.toRequest())
    }
}
