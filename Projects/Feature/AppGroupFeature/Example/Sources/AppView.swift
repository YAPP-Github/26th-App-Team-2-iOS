//
//  AppGroupFeatureView.swift
//  Brake
//
//  Created by Greem on 2025/07/27.
//

import SwiftUI
import Domain
import FeatureAppGroupFeatureInterface
import SharedDesignSystem

@main
struct FeatureAppGroupFeatureApp: App {
    @Environment(\.appGroupDIContainer) var diContainer
    @State private var selectedTab: TabItemType = .dashboard
    var body: some Scene {
        WindowGroup {
            BrakeTabView(selectedTab: $selectedTab)
                .environment(
                    AppGroupMainViewModel(
                        fetchAppGroupUseCase: diContainer.fetchAppGroupUseCase,
                        requestScreenTimeAuthUseCase: diContainer.requestScreenTimeAuthUseCase
                    )
                )
                .safeAreaInset(edge: .bottom) {
                BrakeTabBarView(selectedTabBarItem: $selectedTab)
                    .padding(.bottom, 16)
            }
        }
    }
}

struct BrakeTabView: View {
    @Environment(\.appGroupDIContainer) var diContainer
    @Environment(AppGroupMainViewModel.self) var appGroupViewModel
    @Binding var selectedTab: TabItemType
    var body: some View {
        ZStack {
            switch selectedTab {
            case .report:
                VStack {
                    Spacer()
                    Text("Report")
                    Spacer()
                }
            case .dashboard: AppGroupMainView()
            case .myInfo:
                VStack {
                    Spacer()
                    Text("My Info")
                    Spacer()
                }
            }
            
        }
    }
}
