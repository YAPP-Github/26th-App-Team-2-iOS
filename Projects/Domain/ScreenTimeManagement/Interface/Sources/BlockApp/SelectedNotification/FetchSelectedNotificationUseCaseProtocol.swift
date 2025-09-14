//
//  FetchSelectedNotificationUseCaseProtocol.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 8/3/25.
//

import Foundation

public protocol FetchSelectedNotificationUseCaseProtocol {
    func execute() async throws -> Bool
}
