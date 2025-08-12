//
//  UseCaseDIContainer.swift
//  Brake
//
//  Created by Derrick kim on 2025/08/05.
//

import Foundation
import Domain

public protocol UseCaseDIContainerProtocol {
    var autoLogInUseCase: AutoLogInUseCase { get }
    var onboardingStateUseCase: OnboardingStateUseCase { get }
    var appleLogInUseCase: AppleLogInUseCase { get }
    var kakaoLogInUseCase: KakaoLogInUseCase { get }
    var logInCancelUseCase: LogInCancelUseCase { get }
    var userSetNicknameUseCase: UserSetNicknameUseCase { get }
    
    var requestUserNotificationAuthUseCase: RequestUserNotificationAuthUseCase { get }
    var requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase { get }
    var fetchUserNotificationAuthUseCase: FetchUserNotificationAuthUseCase { get }
    var fetchScreenTimeAuthUseCase: FetchScreenTimeAuthUseCase { get }
    
    var fetchAppGroupUseCase: FetchAppGroupUseCase { get }
    var upsertAppGroupUseCase: UpsertAppGroupUseCase { get }
    var deleteAppGroupUseCase: DeleteAppGroupUseCase { get }
    var createBreakTimeUseCase: CreateBreakTimeUseCaseProtocol { get }
    var fetchSelectedNotificationUseCase: FetchSelectedNotificationUseCaseProtocol { get }
    var fetchAppNameUseCase: FetchAppNameUseCaseProtocol { get }
    var fetchUserNicknameUseCase: FetchUserNicknameUseCaseProtocol { get }
    var deleteUserUseCase: DeleteUserUseCaseProtocol { get }
    var oAuthLogoutUseCase: OAuthLogoutUseCaseProtocol { get }
    
    var createBlockScheduleUseCase: CreateBlockScheduleUseCaseProtocol { get }
    var deleteBlockScheduleUseCase: DeleteBlockScheduleUseCaseProtocol { get }
    var fetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol { get }
    var endBlockScheduleUseCase: EndBlockScheduleUseCaseProtocol { get }
    var getBlockingStatusUseCase: GetBlockingStatusUseCaseProtocol { get }
    var endBreakTimeUseCase: EndBreakTimeUseCaseProtocol { get }
    var endAppBrakeTimeUseCase: EndBreakTimeUseCaseProtocol { get }
    
}

public final class UseCaseDIContainer: UseCaseDIContainerProtocol {
    
    
    
    private let serviceContainer: ServiceDIContainerProtocol
    private let coreContainer: CoreDIContainerProtocol
    
    public init(serviceContainer: ServiceDIContainerProtocol, coreContainer: CoreDIContainerProtocol) {
        self.serviceContainer = serviceContainer
        self.coreContainer = coreContainer
    }
    
    // MARK: - Onboarding UseCases
    @MainActor public lazy var autoLogInUseCase: AutoLogInUseCase = AutoLogInUseCase(
        userValidity: serviceContainer.userValidityService,
        onboardingState: serviceContainer.onboardingStateService
    )
    
    @MainActor public lazy var onboardingStateUseCase: OnboardingStateUseCase = OnboardingStateUseCase(
        onboardingState: serviceContainer.onboardingStateService
    )
    
    @MainActor public lazy var userSetNicknameUseCase: UserSetNicknameUseCase = UserSetNicknameUseCase(
        userProfileService: serviceContainer.userProfileService
    )
    
    @MainActor public lazy var logInCancelUseCase: LogInCancelUseCase = LogInCancelUseCase(
        userProfileService: serviceContainer.userProfileService
    )
    
    @MainActor public lazy var appleLogInUseCase: AppleLogInUseCase = AppleLogInUseCase(
        oAuthService: serviceContainer.oAuthLogInService,
        appleAuthCode: serviceContainer.appleAuthCodeService
    )
    
    @MainActor public lazy var kakaoLogInUseCase: KakaoLogInUseCase = KakaoLogInUseCase(
        oAuthService: serviceContainer.oAuthLogInService
    )
    
    @MainActor public private(set) lazy var requestUserNotificationAuthUseCase: RequestUserNotificationAuthUseCase = RequestUserNotificationAuthUseCase()
    
    @MainActor public private(set) lazy var requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase = RequestScreenTimeAuthUseCase()
    public private(set) lazy var fetchUserNotificationAuthUseCase: FetchUserNotificationAuthUseCase = FetchUserNotificationAuthUseCase()
    
    public private(set) lazy var fetchScreenTimeAuthUseCase: FetchScreenTimeAuthUseCase = FetchScreenTimeAuthUseCase()
    
    @MainActor public lazy var fetchAppGroupUseCase: FetchAppGroupUseCase = FetchAppGroupUseCase(
        appGroupService: serviceContainer.appGroupService
    )
    
    @MainActor public lazy var upsertAppGroupUseCase: UpsertAppGroupUseCase = UpsertAppGroupUseCase(
        appGroupService: serviceContainer.appGroupService
    )
    
    @MainActor public lazy var deleteAppGroupUseCase: DeleteAppGroupUseCase = DeleteAppGroupUseCase(
        appGroupService: serviceContainer.appGroupService
    )
    
    @MainActor public lazy var createBreakTimeUseCase: CreateBreakTimeUseCaseProtocol = CreateBreakTimeUseCase(
        breakTimeManager: coreContainer.breakTimeManager,
        appScheduleStorage: coreContainer.appScheduleStorage
    )
    
    @MainActor public lazy var fetchSelectedNotificationUseCase: FetchSelectedNotificationUseCaseProtocol = FetchSelectedNotificationUseCase(
        appScheduleStorage: coreContainer.appScheduleStorage
    )
    
    @MainActor public lazy var fetchAppNameUseCase: FetchAppNameUseCaseProtocol = FetchAppNameUseCase(
        appScheduleStorage: coreContainer.appScheduleStorage
    )
    
    @MainActor public lazy var fetchUserNicknameUseCase: FetchUserNicknameUseCaseProtocol = FetchUserNicknameUseCase(
        userProfileService: serviceContainer.userProfileService
    )
    
    @MainActor public lazy var deleteUserUseCase: DeleteUserUseCaseProtocol = DeleteUserUseCase(
        userProfileService: serviceContainer.userProfileService
    )
    
    @MainActor public lazy var oAuthLogoutUseCase: OAuthLogoutUseCaseProtocol = OAuthLogoutUseCase(
        oAuthService: serviceContainer.oAuthLogoutService
    )
    
    @MainActor public lazy var createBlockScheduleUseCase: CreateBlockScheduleUseCaseProtocol = CreateBlockScheduleUseCase(blockScheduleManager: coreContainer.blockScheduleManger)
    @MainActor public lazy var deleteBlockScheduleUseCase: DeleteBlockScheduleUseCaseProtocol = DeleteBlockScheduleUseCase(blockScheduleManager: coreContainer.blockScheduleManger)
    @MainActor public lazy var fetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol = FetchBlockScheduleUseCase(blockScheduleManager: coreContainer.blockScheduleManger)
    @MainActor public lazy var endBlockScheduleUseCase: EndBlockScheduleUseCaseProtocol = EndBlockScheduleUseCase(blockScheduleManager: coreContainer.blockScheduleManger)
    @MainActor public lazy var getBlockingStatusUseCase: GetBlockingStatusUseCaseProtocol = GetBlockingStatusUseCase(
        appScheduleStorage: coreContainer.appScheduleStorage,
        cooldownStorage: coreContainer.cooldownStorage
    )
    @MainActor public lazy var endBreakTimeUseCase: EndBreakTimeUseCaseProtocol = EndBreakTimeUseCase(
        appScheduleStorage: coreContainer.appScheduleStorage,
        blockScheduleManager: coreContainer.blockScheduleManger,
        managedSettingsManager: coreContainer.managedSettingsManager,
        cooldownStorage: coreContainer.cooldownStorage
    )
    
    @MainActor public lazy var endAppBrakeTimeUseCase: EndBreakTimeUseCaseProtocol = EndBreakTimeUseCase(
        appScheduleStorage: coreContainer.appScheduleStorage,
        blockScheduleManager: coreContainer.blockScheduleManger,
        managedSettingsManager: coreContainer.managedSettingsManager,
        cooldownStorage: coreContainer.cooldownStorage
    )
}
