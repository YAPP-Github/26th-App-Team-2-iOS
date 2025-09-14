//
//  FetchBlockScheduleUseCaseProtocol.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation

public protocol FetchBlockScheduleUseCaseProtocol {
    func execute(groupTitle: String) -> BlockScheduleEntity?
}
