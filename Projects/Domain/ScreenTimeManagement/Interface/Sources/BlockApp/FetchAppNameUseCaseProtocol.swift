//
//  FetchAppNameUseCaseProtocol.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 8/3/25.
//

import Foundation
import FamilyControls

public protocol FetchAppNameUseCaseProtocol {
    func execute() async throws -> String?
}
