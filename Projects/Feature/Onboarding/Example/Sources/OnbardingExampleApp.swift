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
            VStack {
                ScreenTimeAuthView()
                    .environment(ScreenTimeAuthViewModel())
                UserNotificationAuthView()
                    .environment(UserNotificationAuthViewModel())
            }
            
        }
    }
}


