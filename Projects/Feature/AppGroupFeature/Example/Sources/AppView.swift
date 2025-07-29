//
//  AppGroupFeatureView.swift
//  Brake
//
//  Created by Greem on 2025/07/27.
//

import SwiftUI
import Domain
import Core
import FeatureAppGroupFeatureInterface
import SharedDesignSystem

@main
struct FeatureAppGroupFeatureApp: App {
    @State private var selectedTab: TabItemType = .report
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    AppGroupMainView()
                        .environment(
                            AppGroupMainViewModel(
                                fetchAppGroupUseCase: FetchAppGroupUseCase(
                                    appGroupService: AppGroupService(appGroupStorage: AppGroupStorage())
                                )
                            )
                        )
                }
            }.safeAreaInset(edge: .bottom) {
                BrakeTabBarView(selectedTabBarItem: $selectedTab)
                    .padding(.bottom, 16)
            }
        }
    }
    
}
