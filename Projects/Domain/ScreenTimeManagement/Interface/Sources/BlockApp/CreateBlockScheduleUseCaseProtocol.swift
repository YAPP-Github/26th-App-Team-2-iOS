//
//  CreateBlockScheduleUseCaseProtocol.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 8/1/25.
//

import Foundation
import FamilyControls

public protocol CreateBlockScheduleUseCaseProtocol {
    func execute(schedule: BlockScheduleEntity) throws
}
