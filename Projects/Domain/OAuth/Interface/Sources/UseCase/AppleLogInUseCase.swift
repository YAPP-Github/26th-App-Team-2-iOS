//
//  AppleLogInUseCase.swift
//  DomainOAuth
//
//  Created by Greem on 7/24/25.
//

import Foundation
import DomainUserInterface

public struct AppleLogInUseCase {
    private let oAuthService: OAuthServiceProtocol
    private let appleAuthCode: AppleAuthCodeProtocol
    
    public init(
        oAuthService: OAuthServiceProtocol,
        appleAuthCode: AppleAuthCodeProtocol
    ) {
        self.oAuthService = oAuthService
        self.appleAuthCode = appleAuthCode
    }
    
    public func execute() async throws {
        let authorizationCode = try await appleAuthCode.fetchAuthCode()
        try await oAuthService.login(oAuthType: .apple, authorizationCode: authorizationCode)
    }
}

