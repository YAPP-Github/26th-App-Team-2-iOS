//
//  LogInCancelUseCase.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/31/25.
//

import Foundation
import DomainUserInterface
import DomainSharedInterface


public struct LogInCancelUseCase {
    private let userProfileService: UserProfileProtocol
    
    public init(
        userProfileService: UserProfileProtocol
    ) {
        self.userProfileService = userProfileService
    }
    
    public func execute() async throws {
        try await userProfileService.deleteUser()
    }
}
