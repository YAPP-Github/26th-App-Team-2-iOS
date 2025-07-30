//
//  OAuthLogOutService.swift
//  DomainOAuthInterface
//
//  Created by Greem on 7/31/25.
//

import Foundation
import DomainUserInterface
import Core

public protocol OAuthLogOutServiceProtocol {
    var networkProvider: NetworkProviderProtocol { get }
    var tokenStorage: TokenStorageProtocol { get }
    var tokenKeyHolder: TokenKeyHolderProtocol { get }
    var onboardingState: OnboardingStateProtocol { get }
    
    func logout() async throws
}

public final class OAuthLogOutService {
    public let networkProvider: NetworkProviderProtocol
    public let tokenStorage: TokenStorageProtocol
    public let tokenKeyHolder: TokenKeyHolderProtocol
    public let onboardingState: OnboardingStateProtocol
    
    public init(
        networkProvider: NetworkProviderProtocol,
        tokenStorage: TokenStorageProtocol,
        tokenKeyHolder: TokenKeyHolderProtocol,
        onboardingState: OnboardingStateProtocol
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHolder
        self.onboardingState = onboardingState
    }
}

 
