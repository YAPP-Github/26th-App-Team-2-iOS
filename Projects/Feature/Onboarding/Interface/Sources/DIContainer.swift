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
    var tokenStorage: TokenStorageProtocol { get }
    var memberStateStorage: MemberStateStorageProtocol { get }
    var userStorage: UserStorageProtocol { get }
    
    // Domain Services
    var userValidityService: UserValidityProtocol { get }
    var oAuthLogInService: OAuthServiceProtocol { get }
    var appleAuthCodeService: AppleAuthCodeProtocol { get }
    var userProfileService: UserProfileProtocol { get }
    var onboardingStateService: OnboardingStateProtocol { get }
    
    // Domain Use Cases
    var autoLogInUseCase: AutoLogInUseCase { get }
    var onboardingStateUseCase: OnboardingStateUseCase { get }
    var appleLogInUseCase: AppleLogInUseCase { get }
    var kakaoLogInUseCase: KakaoLogInUseCase  { get }
    var logInCancelUseCase: LogInCancelUseCase { get }
    var userSetNicknameUseCase: UserSetNicknameUseCase { get }
    var requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase { get }
    var requestUserNotificationAuthUseCase: RequestUserNotificationAuthUseCase { get }
}

// MARK: - Production DI Container
public final class OnboardingDIContainer: DIContainerProtocol {

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
    public lazy var userValidityService: UserValidityProtocol = UserValidityService(
        tokenStorage: tokenStorage,
        tokenKeyHolder: tokenKeyHolder,
        networkProviderProtocol: NetworkProvider(networkSession: NetworkSession())
    )
    
    public lazy var onboardingStateService: OnboardingStateProtocol = OnboardingStateService(
        memberStateStorage: memberStateStorage
    )
    
    /// 로그인은 토큰 관련 인터셉터가 없어야한다.
    public lazy var oAuthLogInService: OAuthServiceProtocol = OAuthLogInService(
        networkProvider: NetworkProvider(networkSession: NetworkSession()),
        tokenStorage: tokenStorage,
        tokenKeyHolder: BundleTokenKeyHolder(),
        onboardingState: onboardingStateService
    )
    
    
    public lazy var appleAuthCodeService: AppleAuthCodeProtocol = AppleAuthCodeService()
    
    public lazy var userProfileService: UserProfileProtocol = UserProfileService(
        networkProvider: networkProvider,
        onboardingState: onboardingStateService,
        userStorage: userStorage,
        tokenStorage: tokenStorage
    )
    
    // MARK: -- Domain UseCase
    
    public lazy var autoLogInUseCase: AutoLogInUseCase = AutoLogInUseCase(
        userValidity: userValidityService,
        onboardingState: onboardingStateService
    )
    
    public lazy var onboardingStateUseCase: OnboardingStateUseCase = OnboardingStateUseCase(
        onboardingState: onboardingStateService
    )
    
    public lazy var userSetNicknameUseCase: UserSetNicknameUseCase = UserSetNicknameUseCase(
        userProfileService: userProfileService
    )
    
    public lazy var logInCancelUseCase: LogInCancelUseCase = LogInCancelUseCase(userProfileService: userProfileService)
    
    public lazy var appleLogInUseCase: AppleLogInUseCase = AppleLogInUseCase(
        oAuthService: oAuthLogInService,
        appleAuthCode: appleAuthCodeService
    )
    
    public lazy var kakaoLogInUseCase: KakaoLogInUseCase = KakaoLogInUseCase(
        oAuthService: oAuthLogInService
    )
    
    public lazy var requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase = RequestScreenTimeAuthUseCase()
    public lazy var requestUserNotificationAuthUseCase: RequestUserNotificationAuthUseCase = RequestUserNotificationAuthUseCase()
    
    public init() { }
}


// MARK: - DI Container Environment Key
private struct DIContainerKey: EnvironmentKey {
    static let defaultValue: DIContainerProtocol = OnboardingDIContainer()
}

extension EnvironmentValues {
    public var diContainer: DIContainerProtocol {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}

