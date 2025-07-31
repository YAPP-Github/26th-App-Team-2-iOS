//
//  DeleteBlockAppUseCaseProtocol 2.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation

public protocol DeleteBlockAppUseCaseProtocol {
    func execute(schedule: BlockScheduleEntity) throws
}
