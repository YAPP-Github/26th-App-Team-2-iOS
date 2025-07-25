//
//  UserValidityService.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation
import DomainOAuthInterface
import Core
import SharedUtil

extension UserValidityService: @retroactive UserValidityProtocol {
    
    public func isValid() async throws -> Bool {
        do {
            let accessTokenKey = try tokenKeyHolder.fetchAccessTokenKey()
            let refreshTokenKey = try tokenKeyHolder.fetchRefreshTokenKey()
            let accessToken: AccessToken? = try await tokenStorage.read(key: accessTokenKey)
            let refreshToken: RefreshToken? = try await tokenStorage.read(key: refreshTokenKey)
            
            guard let accessToken, let refreshToken else { return false }
            
            let authRefreshRequest = AuthRefreshRequest(refreshToken: refreshToken.token)
            let refreshEndPoint = BrakeRouter.AuthEndPoint<BrakeResponse<AuthRefreshResponse>>.refresh(authRefreshRequest)
            let refreshResponse: BrakeResponse<AuthRefreshResponse> = try await networkProviderProtocol.request(refreshEndPoint)
            
            try await self.tokenStorage.save(token: AccessToken(token: refreshResponse.data.accessToken), for: accessTokenKey)
            try await self.tokenStorage.save(token: RefreshToken(token: refreshResponse.data.refreshToken), for: refreshTokenKey)
            
            return true
        } catch let error as TokenKeyHolderError {
            throw AuthError.validAuthFailed
        } catch let error as KeychainError {
            throw AuthError.validAuthFailed
        } catch let error as NetworkError {
            throw AuthError.validAuthFailed
        } catch {
            throw AuthError.validAuthFailed
        }
    }
}
