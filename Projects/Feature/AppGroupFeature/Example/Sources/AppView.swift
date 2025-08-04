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
                    requestScreenTimeAuthUseCase: diContainer.requestScreenTimeAuthUseCase,
                    createBlockScheduleUseCase: diContainer.createBlockScheduleUseCase,
                    deleteBlockScheduleUseCase: diContainer.deleteBlockScheduleUseCase,
                    fetchBlockScheduleUseCase: diContainer.fetchBlockScheduleUseCase,
                    endBlockScheduleUseCase: diContainer.endBlockScheduleUseCase,
                    createBreakTimeUseCase: diContainer.createBreakTimeUseCase
                )
            )
        }
    }
}
