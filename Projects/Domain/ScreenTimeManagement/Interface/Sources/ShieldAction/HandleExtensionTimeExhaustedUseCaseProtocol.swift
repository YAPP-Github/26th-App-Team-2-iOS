//
//  HandleExtensionTimeExhaustedUseCaseProtocol.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation

public protocol HandleExtensionTimeExhaustedUseCaseProtocol {
    func execute(groupName: String, cooldownMinutes: Int)
} 
