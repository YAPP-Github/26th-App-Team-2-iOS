//
//  ServiceDIContainer.swift
//  Brake
//
//  Created by Derrick kim on 2025/08/05.
//

import Foundation
import Domain
import Core

public protocol ServiceDIContainerProtocol {
    // MARK: - Domain Services
    var userValidityService: UserValidityProtocol { get }
    var oAuthLogInService: OAuthServiceProtocol { get }
    var oAuthLogoutService: OAuthLogoutServiceProtocol { get }
    var appleAuthCodeService: AppleAuthCodeProtocol { get }
    var userProfileService: UserProfileProtocol { get }
    var onboardingStateService: OnboardingStateProtocol { get }
    var appGroupService: AppGroupProtocol { get }
}

public final class ServiceDIContainer: ServiceDIContainerProtocol {

    private let coreContainer: CoreDIContainerProtocol

    public init(coreContainer: CoreDIContainerProtocol) {
        self.coreContainer = coreContainer
    }

    // MARK: - Domain Services
    @MainActor public lazy var userValidityService: UserValidityProtocol = UserValidityService(
        tokenStorage: coreContainer.tokenStorage,
        tokenKeyHolder: coreContainer.tokenKeyHolder,
        networkProviderProtocol: coreContainer.makeNetworkProvider(hasRequestInterceptor: true)
    )

    @MainActor public lazy var onboardingStateService: OnboardingStateProtocol = OnboardingStateService(
        memberStateStorage: coreContainer.memberStateStorage
    )

    @MainActor public lazy var oAuthLogInService: OAuthServiceProtocol = OAuthLogInService(
        networkProvider: coreContainer.makeNetworkProvider(hasRequestInterceptor: false),
        tokenStorage: coreContainer.tokenStorage,
        tokenKeyHolder: coreContainer.tokenKeyHolder,
        onboardingState: onboardingStateService
    )

    @MainActor public lazy var oAuthLogoutService: OAuthLogoutServiceProtocol = OAuthLogoutService(
        networkProvider: coreContainer.makeNetworkProvider(hasRequestInterceptor: true),
        tokenStorage: coreContainer.tokenStorage,
        tokenKeyHolder: coreContainer.tokenKeyHolder
    )

    @MainActor public lazy var appleAuthCodeService: AppleAuthCodeProtocol = AppleAuthCodeService()

    @MainActor public lazy var userProfileService: UserProfileProtocol = UserProfileService(
        networkProvider: coreContainer.makeNetworkProvider(hasRequestInterceptor: false),
        onboardingState: onboardingStateService,
        userStorage: coreContainer.userStorage,
        tokenStorage: coreContainer.tokenStorage
    )

    @MainActor public lazy var appGroupService: AppGroupProtocol = AppGroupService(appGroupStorage: coreContainer.appGroupStorage)
}
