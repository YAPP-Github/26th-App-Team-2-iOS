//
//  FetchAppGroupUseCase.swift
//  DomainSharedInterface
//
//  Created by Greem on 7/28/25.
//

import Foundation

public struct FetchAppGroupUseCase {
    
    private let appGroupService: AppGroupProtocol
    
    public init(
        appGroupService: AppGroupProtocol
    ) {
        self.appGroupService = appGroupService
    }
    
    public func execute() async throws -> AppGroup? {
        try await appGroupService.getAppGroup()
    }
}
