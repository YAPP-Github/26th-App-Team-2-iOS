//
//  OAuthLogoutService.swift
//  DomainOAuth
//
//  Created by Derrick kim on 8/2/25.
//

import DomainOAuthInterface
import Foundation
import Core

public final class OAuthLogoutService: OAuthLogoutServiceProtocol {

    private let networkProvider: NetworkProviderProtocol
    private let tokenStorage: TokenStorageProtocol
    private let tokenKeyHolder: TokenKeyHolderProtocol

    public init(
        networkProvider: NetworkProviderProtocol,
        tokenStorage: TokenStorageProtocol,
        tokenKeyHolder: TokenKeyHolderProtocol
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHolder
    }

    public func logout() async throws {
        let accessTokenKey: String = try self.tokenKeyHolder.fetchAccessTokenKey()
        let accessToken: AccessToken? = try await tokenStorage.read(key: accessTokenKey)

        guard let accessToken = accessToken else {
            throw AuthError.invalidToken
        }

        let endPoint = BrakeRouter.AuthEndPoint<BrakeResponse<EmptyData>>.logout(
            AuthLogoutRequest(
                accessToken: accessToken.token
            )
        )

        let _: BrakeResponse<EmptyData> = try await networkProvider.request(endPoint)

        // 로그아웃 성공 시 토큰 삭제
        try await tokenStorage.delete(for: accessTokenKey)

        let refreshTokenKey: String = try self.tokenKeyHolder.fetchRefreshTokenKey()
        try await tokenStorage.delete(for: refreshTokenKey)
    }
    
}
