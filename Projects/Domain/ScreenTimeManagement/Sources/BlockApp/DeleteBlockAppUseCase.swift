//
//  DeleteBlockAppUseCase.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import Core
import DomainScreenTimeManagementInterface

public struct DeleteBlockAppUseCase: DeleteBlockAppUseCaseProtocol {

    private let blockScheduleManager: BlockScheduleProtocol

    public init(blockScheduleManager: BlockScheduleProtocol) {
        self.blockScheduleManager = blockScheduleManager
    }

    public func execute(schedule: BlockScheduleEntity) throws {
        blockScheduleManager.delete(schedule.toRequest())
    }
}
