//
//  OnbardingExampleApp.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/22/25.
//

import SwiftUI
import FeatureOnboardingInterface
import SharedUtil
import Domain


@main
struct OnbardingExampleApp: App {
    @State private var startUpViewModel = StartUpViewModel()
    
    init() { }
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch startUpViewModel.userLogInState {
                case .unknown: 
                    EmptyView()
                case .logInRequired:
                    LoginView()
                        .environment(
                        LogInViewModel(
                            appleLogInUseCase: AppleLogInUseCase(
                                oAuthService: OAuthLogInService.make(),
                                appleAuthCode: AppleAuthCodeService.make()
                            ),
                            kakaoLogInUseCase: KakaoLogInUseCase(
                                oAuthService: OAuthLogInService.make()
                            ),
                            logInCompleted: self.startUpViewModel.logInCompleted
                        )
                    )
                case .onboardingRequired:
                    OnboardingView()
                        .environment(startUpViewModel)
                case .brakeAvailable:
                    VStack {
                        Text("홈 화면")
                    }
                    .transition(.opacity)
                case .errorOccured(let userLogInStateError):
                    EmptyView()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: startUpViewModel.userLogInState)
            .onAppear() {
                startUpViewModel.startUpOnAppear()
            }
        }
    }
}

/// 뷰 모델 화면 전환을 위한 Equatable 채택
extension UserLogInStateType: @retroactive Equatable {
    public static func == (lhs: UserLogInStateType, rhs: UserLogInStateType) -> Bool {
        switch (lhs, rhs) {
        case (.brakeAvailable, .brakeAvailable): return true
        case (.errorOccured, .errorOccured): return true
        case (.logInRequired, .logInRequired): return true
        case (.onboardingRequired, .onboardingRequired): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}
