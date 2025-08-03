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
        
        let loginRequest = AuthLogInRequest(
            provider: oAuthType.provider,
            authorizationCode: authorizationCode,
            deviceName: getDeviceIdentifier()
        )
        let endPoint = BrakeRouter.AuthEndPoint<BrakeResponse<AuthLogInResponse>>.logIn(loginRequest)
        let authLogInResponse: BrakeResponse<AuthLogInResponse>
        do {
            authLogInResponse = try await networkProvider.request(endPoint)
        } catch {
            print("로그인 응답 오류: \(error)")
            throw error
        }
        let state: String = authLogInResponse.data.memberState
        guard let stateType = MemberStateType(rawValue: state) else {
            assertionFailure("멤버 타입 변환 오류 \(state)")
            throw AuthError.unknownMemberType
        }
        
        let accessToken = AccessToken(token: authLogInResponse.data.accessToken)
        let refreshToken = RefreshToken(token: authLogInResponse.data.refreshToken)
#if DEBUG
        print("유저 토큰 반환: \n accessToken \(accessToken) \n refreshToken \(refreshToken)")
#endif
        let accessTokenKey = try self.tokenKeyHolder.fetchAccessTokenKey()
        let refreshTokenKey = try self.tokenKeyHolder.fetchRefreshTokenKey()
        
        try await tokenStorage.save(token: accessToken, for: accessTokenKey)
        try await tokenStorage.save(token: refreshToken, for: refreshTokenKey)
        
        self.onboardingState.setMemberState(stateType)
    }
    
    private func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier // 예: "iPhone15,3"
    }
    
    public func logInCancel() async throws {
        
        let accessTokenKey = try self.tokenKeyHolder.fetchAccessTokenKey()
        let refreshTokenKey = try self.tokenKeyHolder.fetchRefreshTokenKey()
        
        try await tokenStorage.delete(for: accessTokenKey)
        try await tokenStorage.delete(for: refreshTokenKey)
        self.onboardingState.setMemberState(.hold)
    }
    
}

