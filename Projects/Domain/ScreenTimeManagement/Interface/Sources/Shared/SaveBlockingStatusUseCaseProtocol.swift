//
//  SaveBlockingStatusUseCaseProtocol.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation

public protocol SaveBlockingStatusUseCaseProtocol {
    func execute(_ status: BlockingStatusEntity)
} 
