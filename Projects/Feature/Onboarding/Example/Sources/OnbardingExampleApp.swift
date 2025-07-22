//
//  OnbardingExampleApp.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/22/25.
//

import SwiftUI
import FeatureOnboardingInterface
import DomainOAuthInterface

@main
struct OnbardingExampleApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(
                    LogInViewModel(
                        appleLogInUseCase: OAuthLogInUseCase.make(authType: .apple)
                    )
                )
        }
    }
}


