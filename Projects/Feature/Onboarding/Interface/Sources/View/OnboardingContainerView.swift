//
//  OnboardingContainerView.swift
//  FeatureOnboardingInterface
//
//  Created by Assistant on 2025-01-02.
//

import SwiftUI

public struct OnboardingContainerView: View {
    private let startUpViewModel: StartUpViewModel
    
    // 모든 ViewModel을 여기서 한 번에 생성
    @State private var setNickNameViewModel = SetNickNameViewModel()
    @State private var screenTimeAuthViewModel: ScreenTimeAuthViewModel?
    @State private var userNotificationAuthViewModel: UserNotificationAuthViewModel?
    @State private var onboardingCompletedViewModel: OnboardingCompletedViewModel?
    
    public init(startUpViewModel: StartUpViewModel) {
        self.startUpViewModel = startUpViewModel
    }
    
    public var body: some View {
        NavigationStack {
            SetNickNameView()
        }
        // 모든 ViewModel을 한 번에 environment에 주입
        .environment(startUpViewModel)
        .environment(setNickNameViewModel)
        .environment(screenTimeAuthViewModel ?? makeScreenTimeAuthViewModel())
        .environment(userNotificationAuthViewModel ?? makeUserNotificationAuthViewModel())
        .onAppear {
            setupViewModels()
        }
    }
    
    private func setupViewModels() {
        if screenTimeAuthViewModel == nil {
            screenTimeAuthViewModel = makeScreenTimeAuthViewModel()
        }
        if userNotificationAuthViewModel == nil {
            userNotificationAuthViewModel = makeUserNotificationAuthViewModel()
        }
    }
    
    private func makeScreenTimeAuthViewModel() -> ScreenTimeAuthViewModel {
        ScreenTimeAuthViewModel(
            requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase()
        )
    }
    
    private func makeUserNotificationAuthViewModel() -> UserNotificationAuthViewModel {
        UserNotificationAuthViewModel(
            requestUserNotificationAuthUseCase: RequestUserNotificationAuthUseCase()
        )
    }
    
    private func makeOnboardingCompletedViewModel() -> OnboardingCompletedViewModel {
        OnboardingCompletedViewModel(
            userName: setNickNameViewModel.nickName,
            userOnboardingFinishedUseCase: UserOnboardingFinishedUseCase(),
            onboardingCompleted: startUpViewModel.onboardingCompleted
        )
    }
} 