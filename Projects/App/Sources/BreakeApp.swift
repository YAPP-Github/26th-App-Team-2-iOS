//
//  BreakeApp.swift
//  Brake
//
//  Created by Derrick kim on 2025/01/27.
//

import SwiftUI
import SharedDesignSystem
import FeatureOnboardingInterface

@main
struct BreakeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.appDIContainer) var appDIContainer

    var body: some Scene {
        WindowGroup {
            MainAppView()
                .environment(
                    StartUpViewModel(
                        autoLogInUseCase: appDIContainer.useCaseContainer.autoLogInUseCase,
                        onboardingStateUseCase: appDIContainer.useCaseContainer.onboardingStateUseCase
                    )
                )
        }
    }
}
