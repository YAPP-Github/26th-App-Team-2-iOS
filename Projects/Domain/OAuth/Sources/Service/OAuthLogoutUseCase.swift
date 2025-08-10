//
//  OAuthLogoutUseCase.swift
//  DomainOAuth
//
//  Created by Derrick kim on 8/2/25.
//

import DomainOAuthInterface
import DomainUserInterface
import DomainSharedInterface

public struct OAuthLogoutUseCase: OAuthLogoutUseCaseProtocol {

    private let oAuthService: OAuthLogoutServiceProtocol

    public init(
        oAuthService: OAuthLogoutServiceProtocol
    ) {
        self.oAuthService = oAuthService
    }

    public func execute() async throws {
        try await oAuthService.logout()
    }
}
