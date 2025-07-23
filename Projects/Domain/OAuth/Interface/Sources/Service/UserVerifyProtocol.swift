//
//  UserVerifyProtocol.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/23/25.
//

import Foundation
import CoreNetworkInterface
import CoreLocalStorageInterface
import UIKit.UIDevice

protocol UserVerifyProtocol {
    var networkProvider: NetworkProviderProtocol { get }
    var tokenStorage: TokenStorageProtocol { get }
    var keyHodler: TokenKeyHolderProtocol { get }
    
    func verify(oAuthType: OAuthType, authorizationCode: String) async throws
}


fileprivate extension OAuthType {
    var provider: String {
        switch self {
        case .apple: "APPLE"
        case .kakao: "KAKAO"
        }
    }
}

extension UserVerifyProtocol {
    func verify(oAuthType: OAuthType, authorizationCode: String) async throws {
        
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
        
        
    }
}
