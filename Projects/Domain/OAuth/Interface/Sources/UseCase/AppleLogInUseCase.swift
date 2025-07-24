//
//  AppleLogInUseCase.swift
//  DomainOAuth
//
//  Created by Greem on 7/24/25.
//

import Foundation

public struct AppleLogInUseCase {
    private let oAuthService: OAuthServiceProtocol
    private let appleAuthCodeProtocol: AppleAuthCodeProtocol
    
    public init(
        oAuthService: OAuthServiceProtocol,
        appleAuthCodeProtocol: AppleAuthCodeProtocol
    ) {
        self.oAuthService = oAuthService
        self.appleAuthCodeProtocol = appleAuthCodeProtocol
    }
    
    public func execute() async throws {
        let authorizationCode = try await appleAuthCodeProtocol.fetchAuthCode()
        try await oAuthService.login(oAuthType: .apple, authorizationCode: authorizationCode)
    }
}
