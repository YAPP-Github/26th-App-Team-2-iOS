//
//  OnboardingViewModelFactory.swift
//  FeatureOnboardingInterface
//
//  Created by Assistant on 2025-01-02.
//

import Foundation
import Domain

@MainActor
public class OnboardingViewModelFactory: ObservableObject {
    
    private let startUpViewModel: StartUpViewModel
    
    public init(startUpViewModel: StartUpViewModel) {
        self.startUpViewModel = startUpViewModel
    }
    
    public func makeSetNickNameViewModel() -> SetNickNameViewModel {
        SetNickNameViewModel()
    }
    
    public func makeScreenTimeAuthViewModel() -> ScreenTimeAuthViewModel {
        ScreenTimeAuthViewModel(
            requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase()
        )
    }
    
    public func makeUserNotificationAuthViewModel() -> UserNotificationAuthViewModel {
        UserNotificationAuthViewModel(
            requestUserNotificationAuthUseCase: RequestUserNotificationAuthUseCase()
        )
    }
    
    public func makeOnboardingCompletedViewModel(userName: String) -> OnboardingCompletedViewModel {
        OnboardingCompletedViewModel(
            userName: userName,
            userOnboardingFinishedUseCase: UserOnboardingFinishedUseCase(),
            onboardingCompleted: startUpViewModel.onboardingCompleted
        )
    }
} 