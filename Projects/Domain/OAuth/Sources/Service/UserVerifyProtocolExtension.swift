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
    public func verify(
        oAuthType: OAuthType,
        authorizationCode: String
    ) async throws {
        
        let loginRequest = AuthLogInRequest(
            provider: oAuthType.provider,
            authorizationCode: authorizationCode,
            deviceId: UUID().uuidString
        )
        print("request Value: \(loginRequest)")
        let endPoint = BrakeRouter.AuthEndPoint<BrakeResponse<AuthLogInResponse>>.logIn(loginRequest)
        
        let response: BrakeResponse<AuthLogInResponse> = try await networkProvider.request(endPoint)
        
        let state: String = response.data.memberState
        guard let stateType = MemberStateType(rawValue: state) else {
            assertionFailure("멤버 타입 변환 오류 \(state)")
            throw AuthError.unknownMemberType
        }
        
        let accessToken = AccessToken(token: response.data.accessToken)
        let refreshToken = RefreshToken(token: response.data.refreshToken)
        print("로그인 쌉 가능 accessToken: \(accessToken) refreshToken: \(refreshToken)")
//        let accessTokenKey = try self.tokenKeyHodler.fetchAccessTokenKey()
//        let refreshTokenKey = try self.tokenKeyHodler.fetchRefreshTokenKey()
//
//        try await tokenStorage.save(token: accessToken, for: accessTokenKey)
//        try await tokenStorage.save(token: refreshToken, for: refreshTokenKey)
//        
//        self.memberStateStorage.save(memberState: stateType)
    }
}

fileprivate extension MemberStateType {
    private static let activeRawValue = "ACTIVE"
    private static let holdRawValue = "HOLD"
    init?(rawValue: String) {
        switch rawValue {
        case Self.activeRawValue: self = .active
        case Self.holdRawValue: self = .hold
        default: return nil
        }
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
