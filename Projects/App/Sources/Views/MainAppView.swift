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

struct MainAppView: View {
    @Environment(\.appDIContainer) private var appDIContainer
    @Environment(StartUpViewModel.self) var startUpViewModel
    
    var body: some View {
       ZStack {
           switch startUpViewModel.userLogInState {
           case .unknown:
               EmptyView()
           case .logInRequired:
               LoginView()
                   .environment(
                       LogInViewModel(
                           appleLogInUseCase: appDIContainer.useCaseContainer.appleLogInUseCase,
                           kakaoLogInUseCase: appDIContainer.useCaseContainer.kakaoLogInUseCase,
                           localLogInUseCase: appDIContainer.useCaseContainer.localLogInUseCase,
                           logInCompleted: startUpViewModel.logInCompleted
                       )
                   )
           case .onboardingRequired:
               OnboardingView()
                   .environment(startUpViewModel)
           case .brakeAvailable:
               MainTabView()
                .environment(
                    MainAppViewModel(
                        fetchScreenTimeAuthUseCase: appDIContainer.useCaseContainer.fetchScreenTimeAuthUseCase,
                        fetchNotificationAuthUseCase: appDIContainer.useCaseContainer.fetchUserNotificationAuthUseCase
                    )
                )
                .environment(startUpViewModel)
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
