//
//  CreateBreakTimeUseCaseProtocol.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation

public protocol CreateBreakTimeUseCaseProtocol {
    func execute(by minutes: Int) throws
}
