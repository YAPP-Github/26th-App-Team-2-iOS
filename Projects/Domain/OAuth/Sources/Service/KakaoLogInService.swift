//
//  KakaoLogInService.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation
import DomainOAuthInterface
import KakaoSDKUser
import KakaoSDKAuth

extension KakaoLogInService: @retroactive OAuthServiceProtocol, @retroactive UserVerifyProtocol {
    
    
    public func login() async throws -> OAuthType {
        let result: OAuthToken = try await accessFromKakaoLogIn()
        let accessToken = result.accessToken
        try await self.verify(oAuthType: .kakao, authorizationCode: accessToken)
        return .kakao
    }
    
    @MainActor private func accessFromKakaoLogIn() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else if let oauthToken {
                        continuation.resume(returning: oauthToken)
                    } else {
                        continuation.resume(throwing: AuthError.invalidToken)
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else if let oauthToken {
                        continuation.resume(returning: oauthToken)
                    } else {
                        continuation.resume(throwing: AuthError.invalidToken)
                    }
                }
            }
        }
    }
}
