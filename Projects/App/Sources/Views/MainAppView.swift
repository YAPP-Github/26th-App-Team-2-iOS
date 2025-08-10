//
//  MainAppView.swift
//  Brake
//
//  Created by Derrick kim on 2025/08/05.
//

import SwiftUI
import SharedDesignSystem
import FeatureOnboardingInterface
import FeatureAppGroupFeatureInterface
import FeatureMyInfoInterface
import Domain

struct MainAppView: View {
    @Environment(\.appDIContainer) private var appDIContainer
    @Environment(StartUpViewModel.self) var startUpViewModel
    
    var body: some View {
        ZStack {
            Color.grey900.ignoresSafeArea()
            switch startUpViewModel.userLogInState {
            case .unknown:
                EmptyView()
            case .logInRequired:
                LoginView()
                    .environment(
                        LogInViewModel(
                            appleLogInUseCase: appDIContainer.useCaseContainer.appleLogInUseCase,
                            kakaoLogInUseCase: appDIContainer.useCaseContainer.kakaoLogInUseCase,
                            logInCompleted: startUpViewModel.logInCompleted
                        )
                    )
            case .onboardingRequired:
                OnboardingView()
                    .environment(startUpViewModel)
            case .brakeAvailable:
                MainTabView().environment(startUpViewModel)
            case .errorOccured:
                EmptyView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: startUpViewModel.userLogInState)
        .onAppear {
            startUpViewModel.startUpOnAppear()
        }
    }
}
