//
//  OAuthLogInService.swift
//  DomainOAuth
//
//  Created by Greem on 7/24/25.
//

import Foundation
import DomainOAuthInterface

extension OAuthLogInService: @retroactive OAuthServiceProtocol, @retroactive UserVerifyProtocol {
    
    public func login(oAuthType: OAuthType, authorizationCode: String) async throws {
        try await self.verify(oAuthType: oAuthType, authorizationCode: authorizationCode)
    }
}
