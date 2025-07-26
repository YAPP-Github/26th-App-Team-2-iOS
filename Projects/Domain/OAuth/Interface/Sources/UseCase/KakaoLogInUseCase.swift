//
//  KakaoLogInUseCase.swift
//  DomainOAuth
//
//  Created by Greem on 7/22/25.
//

import Foundation

public struct KakaoLogInUseCase {
    private let oAuthService: OAuthServiceProtocol
    
    public init(oAuthService: OAuthServiceProtocol) {
        self.oAuthService = oAuthService
    }
    
    public func execute(authorizationCode: String) async throws {
        try await oAuthService.login(oAuthType: .kakao, authorizationCode: authorizationCode)
    }
}
