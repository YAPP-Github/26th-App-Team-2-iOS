//
//  UserVerifyProtocolExtension.swift
//  DomainOAuth
//
//  Created by Greem on 7/23/25.
//

import Foundation
import DomainOAuthInterface
import CoreNetworkInterface
import CoreLocalStorageInterface
import UIKit.UIDevice

extension UserVerifyProtocol {
    func verify(
        oAuthType: OAuthType,
        authorizationCode: String
    ) async throws {
        
        let loginRequest = await AuthLogInRequest(
            provider: oAuthType.provider,
            authorizationCode: authorizationCode,
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? ""
        )
        
        let endPoint = BrakeRouter.AuthEndPoint<BrakeResponse<AuthLogInResponse>>.logIn(loginRequest)
        
        let response: BrakeResponse<AuthLogInResponse> = try await networkProvider.request(endPoint)
        
        let state = response.data.memberState
        
        let accessToken = AccessToken(token: response.data.accessToken, expiration: .now)
        let refreshToken = RefreshToken(token: response.data.refreshToken, expiration: .now)
        
        let accessTokenKey = try self.tokenKeyHodler.fetchAccessTokenKey()
        let refreshTokenKey = try self.tokenKeyHodler.fetchRefreshTokenKey()

        try await tokenStorage.save(token: accessToken, for: accessTokenKey)
        try await tokenStorage.save(token: refreshToken, for: refreshTokenKey)
        
//        try userInfoStorage.save(userInformation: .init(userID: userID))
    }
}

fileprivate extension OAuthType {
    var provider: String {
        switch self {
        case .apple: "APPLE"
        case .kakao: "KAKAO"
        }
    }
}
