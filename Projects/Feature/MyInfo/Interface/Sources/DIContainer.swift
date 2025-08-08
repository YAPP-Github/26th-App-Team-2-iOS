//
//  DIContainer.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/27/25.
//

import SwiftUI
import Domain
import Core
import SharedUtil

// MARK: - DI Container Protocol
public protocol DIContainerProtocol {
    // Core Network
    var networkProvider: NetworkProviderProtocol { get }
    var tokenInterceptor: TokenInterceptor { get }

    // Core Storages
    var memberStateStorage: MemberStateStorageProtocol { get }
    var userStorage: UserStorageProtocol { get }
    
    // Domain Services
    var userProfileService: UserProfileProtocol { get }
    var onboardingStateService: OnboardingStateProtocol { get }
    var oAuthLogoutService: OAuthLogoutServiceProtocol { get }

    // Domain Use Cases
    var userSetNicknameUseCase: UserSetNicknameUseCase { get }
    var fetchUserNicknameUseCase: FetchUserNicknameUseCaseProtocol { get }
    var deleteUserUseCase: DeleteUserUseCaseProtocol { get }
    var oAuthLogoutUseCase: OAuthLogoutUseCaseProtocol { get }
}

// MARK: - Production DI Container
public final class MyInfoDIContainer: DIContainerProtocol {

    public init() { }
    // MARK: -- Core Layer
    // Lazy 프로퍼티로 필요할 때만 생성
    public lazy var tokenStorage: TokenStorageProtocol = KeyChainTokenStorage()
    public lazy var memberStateStorage: MemberStateStorageProtocol = UserDefaultsMemberStateStorage()
    public lazy var userStorage: UserStorageProtocol = UserDefaultsUserStorage()
    public lazy var tokenKeyHolder: TokenKeyHolderProtocol = BundleTokenKeyHolder()

    public lazy var tokenInterceptor: TokenInterceptor = TokenInterceptor(
        tokenStorage: tokenStorage,
        tokenKeyHolder: tokenKeyHolder
    )

    public lazy var networkProvider: NetworkProviderProtocol = NetworkProvider(
        networkSession: NetworkSession(
            requestInterceptor: tokenInterceptor,
            urlSession: .shared
        ),
        urlComponentConfig: .default
    )

    // MARK: -- Domain Services

    public lazy var onboardingStateService: OnboardingStateProtocol = OnboardingStateService(
        memberStateStorage: memberStateStorage
    )

    public lazy var oAuthLogoutService: OAuthLogoutServiceProtocol = OAuthLogoutService(
        networkProvider: networkProvider,
        tokenStorage: tokenStorage,
        tokenKeyHolder: tokenKeyHolder
    )

    public lazy var userProfileService: UserProfileProtocol = UserProfileService(
        networkProvider: networkProvider,
        onboardingState: onboardingStateService,
        userStorage: userStorage,
        tokenStorage: tokenStorage
    )
    
    // MARK: -- Domain UseCase
    public lazy var userSetNicknameUseCase: UserSetNicknameUseCase = UserSetNicknameUseCase(
        userProfileService: userProfileService
    )

    public lazy var fetchUserNicknameUseCase: FetchUserNicknameUseCaseProtocol = FetchUserNicknameUseCase(
        userProfileService: userProfileService
    )

    public lazy var deleteUserUseCase: DeleteUserUseCaseProtocol = DeleteUserUseCase(
        userProfileService: userProfileService
    )

    public lazy var oAuthLogoutUseCase: OAuthLogoutUseCaseProtocol = OAuthLogoutUseCase(
        oAuthService: oAuthLogoutService
    )

}

// MARK: - DI Container Environment Key
private struct DIContainerKey: EnvironmentKey {
    static let defaultValue: DIContainerProtocol = MyInfoDIContainer()
}

extension EnvironmentValues {
    public var diContainer: DIContainerProtocol {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}

