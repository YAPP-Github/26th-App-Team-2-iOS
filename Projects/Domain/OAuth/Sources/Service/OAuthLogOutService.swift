//
//  OAuthLogOutService.swift
//  DomainOAuth
//
//  Created by Greem on 7/31/25.
//

import Foundation
import DomainOAuthInterface
import Core

extension OAuthLogOutService: @retroactive OAuthLogOutServiceProtocol {
    public func logout() async throws {
        let accessTokenKey = try self.tokenKeyHolder.fetchAccessTokenKey()
        let refreshTokenKey = try self.tokenKeyHolder.fetchRefreshTokenKey()
        guard let accessToken: AccessToken = try await tokenStorage.read(key: accessTokenKey) else {
            throw TokenKeyHolderError.accessTokenKeyMissing
        }
        
        do {
            let endPoint = BrakeRouter.AuthEndPoint<EmptyData>.logOut(accessToken: accessToken.token)
            _ = try await networkProvider.request(endPoint)
            try await tokenStorage.delete(for: accessTokenKey)
            try await tokenStorage.delete(for: refreshTokenKey)
            self.onboardingState.setMemberState(.hold)
        } catch {
            print("로그아웃 네트워크 오류: \(error)")
            // 로그아웃 네트워크 실패 시에도 로컬 토큰은 삭제
        }
    }
}
