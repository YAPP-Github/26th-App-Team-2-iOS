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
            BrakeTabView(selectedTab: $selectedTab) { selectedTab in
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
                            .environment(
                                AppGroupMainViewModel(
                                    fetchAppGroupUseCase: diContainer.fetchAppGroupUseCase,
                                    requestScreenTimeAuthUseCase: diContainer.requestScreenTimeAuthUseCase
                                )
                            )
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
    }
}

struct BrakeTabView<Content: View>: View {
    @Binding var selectedTab: TabItemType
    @State private var bottomInsetHeight: CGFloat = 0
    
    private let content: (TabItemType) -> Content
    
    init(selectedTab: Binding<TabItemType> ,content: @escaping (TabItemType) -> Content) {
        self._selectedTab = selectedTab
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.content(selectedTab)
                .environment(\.bottomInsetHeight, bottomInsetHeight)
                .onAppear { bottomInsetHeight = geometry.safeAreaInsets.bottom }
        }.safeAreaInset(edge: .bottom) {
            BrakeTabBarView(selectedTabBarItem: $selectedTab)
                .padding(.bottom, 16)
        }
    }
}
