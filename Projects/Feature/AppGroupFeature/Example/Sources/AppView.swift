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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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
    @State private var bottomInsetHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                switch selectedTab {
                case .report:
                    VStack {
                        Spacer()
                        Text("Report")
                        Spacer()
                    }
                case .dashboard:
                    AppGroupMainView()
                        .environment(\.bottomInsetHeight, bottomInsetHeight)
                case .myInfo:
                    VStack {
                        Spacer()
                        Text("My Info")
                        Spacer()
                    }
                }
            }
            .onAppear {
                bottomInsetHeight = geometry.safeAreaInsets.bottom
            }
        }
    }
}
