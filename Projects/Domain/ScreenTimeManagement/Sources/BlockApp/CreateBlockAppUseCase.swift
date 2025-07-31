//
//  CreateBlockAppUseCase.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import Core
import DomainScreenTimeManagementInterface

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
