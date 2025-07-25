//
//  OAuthLogInService.swift
//  DomainOAuth
//
//  Created by Greem on 7/24/25.
//

import Foundation
import Core
import DomainOAuthInterface
import UIKit.UIDevice

extension OAuthLogInService: @retroactive OAuthServiceProtocol { }

extension OAuthServiceProtocol {
    public func login(
        oAuthType: OAuthType,
        authorizationCode: String
    ) async throws {
        let loginRequest = await AuthLogInRequest(
            provider: oAuthType.provider,
            authorizationCode: authorizationCode,
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        )
        let endPoint = BrakeRouter.AuthEndPoint<BrakeResponse<AuthLogInResponse>>.logIn(loginRequest)
        
        let response: BrakeResponse<AuthLogInResponse> = try await networkProvider.request(endPoint)
        
        let state: String = response.data.memberState
        guard let stateType = MemberStateType(rawValue: state) else {
            assertionFailure("멤버 타입 변환 오류 \(state)")
            throw AuthError.unknownMemberType
        }
        
        let accessToken = AccessToken(token: response.data.accessToken)
        let refreshToken = RefreshToken(token: response.data.refreshToken)
        let accessTokenKey = try self.tokenKeyHolder.fetchAccessTokenKey()
        let refreshTokenKey = try self.tokenKeyHolder.fetchRefreshTokenKey()

        try await tokenStorage.save(token: accessToken, for: accessTokenKey)
        try await tokenStorage.save(token: refreshToken, for: refreshTokenKey)
        
        self.memberStateStorage.save(memberState: stateType)
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
