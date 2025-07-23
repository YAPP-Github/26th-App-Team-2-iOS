//
//  AutoLogInUseCase.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation

public struct AutoLogInUseCase {
    private let userValidityService: OAuthServiceProtocol
    
    public init(userValidityService: OAuthServiceProtocol) {
        self.userValidityService = userValidityService
    }
    
    public func execute() async throws {
//        return try await userValidityService.login(isAutoLogin: true)
        
    }
}
