//
//  EndBlockScheduleUseCaseProtocol.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation

public protocol EndBlockScheduleUseCaseProtocol {
    func execute(schedule: BlockScheduleEntity) throws
} 
