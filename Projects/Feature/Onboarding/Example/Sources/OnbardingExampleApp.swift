//
//  OnbardingExampleApp.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/22/25.
//

import SwiftUI
import FeatureOnboardingInterface

@main
struct OnbardingExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ScreenTimeAuthView()
                    .environment(ScreenTimeAuthViewModel(
                        requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase()
                    ))
            }
        }
    }
}


