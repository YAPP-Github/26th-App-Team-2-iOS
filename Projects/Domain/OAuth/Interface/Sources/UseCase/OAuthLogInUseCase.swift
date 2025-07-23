//
//  OAuthLogInUseCase.swift
//  DomainOAuth
//
//  Created by Greem on 7/22/25.
//

import Foundation
import CoreNetworkInterface
import CoreLocalStorageInterface

public struct OAuthLogInUseCase {
    private let oAuthService: OAuthServiceProtocol
    
    public static func make(authType: OAuthType) -> Self {
        switch authType {
        case .apple:
            OAuthLogInUseCase(
                oAuthService: AppleLogInService(
                    networkProvider: NetworkProvider(networkSession: NetworkSession()) as! NetworkProviderProtocol
                )  as! OAuthServiceProtocol
            )
        case .kakao:
            OAuthLogInUseCase(
                oAuthService: KakaoLogInService() as! OAuthServiceProtocol
            )
        }
    }
    
    init(oAuthService: OAuthServiceProtocol) {
        self.oAuthService = oAuthService
    }
    
    public func execute() async throws -> OAuthType {
        return try await oAuthService.login()
    }
}
