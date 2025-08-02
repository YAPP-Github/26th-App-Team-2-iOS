//
//  CreateBlockAppUseCaseProtocol.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation

public protocol CreateBlockAppUseCaseProtocol {
    func execute(schedule: BlockScheduleEntity) throws
}
