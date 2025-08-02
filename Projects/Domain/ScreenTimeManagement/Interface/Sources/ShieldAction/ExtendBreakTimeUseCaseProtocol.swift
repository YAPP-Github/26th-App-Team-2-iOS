//
//  ExtendBreakTimeUseCaseProtocol.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation

public protocol ExtendBreakTimeUseCaseProtocol {
    func execute(time: Int, count: Int) throws -> Bool
} 
