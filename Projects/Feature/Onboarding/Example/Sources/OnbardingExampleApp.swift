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
                if startUpViewModel.isLogInCompleted {
                    if startUpViewModel.isOnboardingCompleted {
                        VStack {
                            Text("홈 화면")
                        }
                    } else {
                        OnboardingView()
                    }
                } else {
                    NavigationStack {
                SetNickNameView()
            }
                        .environment(
                            LogInViewModel(
                                appleLogInUseCase: AppleLogInUseCase(
                                    oAuthService: OAuthLogInService.make(),
                                    appleAuthCode: AppleAuthCodeService.make()
                                ),
                                kakaoLogInUseCase: KakaoLogInUseCase(
                                    oAuthService: OAuthLogInService.make()
                                ),
                                delegate: startUpViewModel
                            )
                        )
                }
            }
            .onAppear() {
                startUpViewModel.startUpOnAppear()
            }
        }
    }
}
