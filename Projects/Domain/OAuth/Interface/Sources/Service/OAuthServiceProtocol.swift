//
//  OAuthServiceProtocol.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/22/25.
//

import Foundation
import DomainUserInterface
import Core


public protocol OAuthServiceProtocol {
    var networkProvider: NetworkProviderProtocol { get }
    var tokenStorage: TokenStorageProtocol { get }
    var tokenKeyHolder: TokenKeyHolderProtocol { get }
    var onboardingState: OnboardingStateProtocol { get }
    
    func login(oAuthType: OAuthType, authorizationCode: String) async throws
}

public final class OAuthLogInService {
    public let networkProvider: NetworkProviderProtocol
    public let tokenStorage: TokenStorageProtocol
    public let tokenKeyHolder: TokenKeyHolderProtocol
    public let onboardingState: OnboardingStateProtocol
    
    public static func make() -> OAuthLogInService {
        OAuthLogInService(
            networkProvider: NetworkProvider(networkSession: NetworkSession()),
            tokenStorage: KeyChainTokenStorage(),
            tokenKeyHodler: BundleTokenKeyHolder(),
            onboardingState: OnboardingStateService(
                memberStateStorage: UserDefaultsMemberStateStorage()
            ) as! OnboardingStateProtocol
        )
    }

    public init(
        networkProvider: NetworkProviderProtocol,
        tokenStorage: TokenStorageProtocol,
        tokenKeyHodler: TokenKeyHolderProtocol,
        onboardingState: OnboardingStateProtocol
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHodler
        self.onboardingState = onboardingState
    }
    
}
