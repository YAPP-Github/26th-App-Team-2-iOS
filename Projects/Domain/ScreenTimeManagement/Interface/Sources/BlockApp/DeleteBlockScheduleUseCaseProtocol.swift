//
//  DeleteBlockScheduleUseCaseProtocol.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 8/1/25.
//

import Foundation

public protocol DeleteBlockScheduleUseCaseProtocol {
    func execute(schedule: BlockScheduleEntity)
}
