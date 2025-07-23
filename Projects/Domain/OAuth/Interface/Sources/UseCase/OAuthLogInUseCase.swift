//
//  OAuthLogInUseCase.swift
//  DomainOAuth
//
//  Created by Greem on 7/22/25.
//

import Foundation
import CoreNetworkInterface
import CoreLocalStorageInterface
import Core

public struct OAuthLogInUseCase {
    private let oAuthService: OAuthServiceProtocol
    
    public init(oAuthService: OAuthServiceProtocol) {
        self.oAuthService = oAuthService
    }
    
    public func execute() async throws -> OAuthType {
        return try await oAuthService.login()
    }
}
