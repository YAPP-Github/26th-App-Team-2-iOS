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
    @State var isTabBarHidden: Bool = false

    var body: some Scene {
        WindowGroup {
            appGroupMainView
        }
    }
    @ViewBuilder
    var appGroupMainView: some View {
        BrakeTabView(selectedTab: $selectedTab) { selectedTab in
            ZStack {
                switch selectedTab {
                case .dashboard:
                    AppGroupMainView()
                        .task {
                            let screenTimeAuthorizationResult = await diContainer.requestScreenTimeAuthUseCase.execute()
                            let notificationAuthorizationResult = await diContainer.requestUserNotificationAuthUseCase.execute()
                        }
                case .myInfo:
                    VStack {
                        Spacer()
                        Text("My Info")
                        Spacer()
                    }
                }
            }
            
        }
        .environment(
            AppGroupMainViewModel(
                fetchAppGroupUseCase: diContainer.fetchAppGroupUseCase,
                fetchSelectedNotificationUseCase: diContainer.fetchSelectedNotificationUseCase,
                createBlockScheduleUseCase: diContainer.createBlockScheduleUseCase,
                deleteBlockScheduleUseCase: diContainer.deleteBlockScheduleUseCase,
                fetchBlockScheduleUseCase: diContainer.fetchBlockScheduleUseCase,
                endBlockScheduleUseCase: diContainer.endBlockScheduleUseCase,
                getBlockingStatusUseCase: diContainer.getBlockingStatusUseCase,
                endBreakTimeUseCase: diContainer.endAppBrakeTimeUseCase
            )
        )
        
    }
}



