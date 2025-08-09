//
//  MainTabView.swift
//  Brake
//
//  Created by Derrick kim on 2025/08/05..
//

import SwiftUI
import SharedDesignSystem
import FeatureAppGroupFeatureInterface
import FeatureMyInfoInterface
import FeatureOnboardingInterface

struct MainTabView: View {
    @Environment(\.appDIContainer) private var appDIContainer
    @Environment(StartUpViewModel.self) var startUpViewModel

    @State private var selectedTab: TabItemType = .dashboard
//    @State private var isTabBarHidden: Bool = false

    var body: some View {
        BrakeTabView(
            selectedTab: $selectedTab
//            isTabBarHidden: $isTabBarHidden
        ) { selectedTab in
            ZStack {
                Color.grey900.ignoresSafeArea()
                switch selectedTab {
                case .dashboard: AppGroupMainView()
                case .myInfo: MyInfoSettingView(/*isTabBarHidden: $isTabBarHidden*/)
                }
            }
            
        }.environment(
            AppGroupMainViewModel(
                fetchAppGroupUseCase: appDIContainer.useCaseContainer.fetchAppGroupUseCase,
                requestScreenTimeAuthUseCase: appDIContainer.useCaseContainer.requestScreenTimeAuthUseCase,
                fetchSelectedNotificationUseCase: appDIContainer.useCaseContainer.fetchSelectedNotificationUseCase,
                createBlockScheduleUseCase: appDIContainer.useCaseContainer.createBlockScheduleUseCase,
                deleteBlockScheduleUseCase: appDIContainer.useCaseContainer.deleteBlockScheduleUseCase,
                fetchBlockScheduleUseCase: appDIContainer.useCaseContainer.fetchBlockScheduleUseCase,
                endBlockScheduleUseCase: appDIContainer.useCaseContainer.endBlockScheduleUseCase,
                getBlockingStatusUseCase: appDIContainer.useCaseContainer.getBlockingStatusUseCase,
                endBreakTimeUseCase: appDIContainer.useCaseContainer.endBreakTimeUseCase
            )
        )
        .environment(
            MyInfoSettingViewModel(
                fetchUserNicknameUseCase: appDIContainer.useCaseContainer.fetchUserNicknameUseCase,
                userSetNicknameUseCase: appDIContainer.useCaseContainer.userSetNicknameUseCase,
                deleteUserUseCase: appDIContainer.useCaseContainer.deleteUserUseCase,
                oAuthLogoutUseCase: appDIContainer.useCaseContainer.oAuthLogoutUseCase,
                onLogout: {
                    startUpViewModel.logout()
                }
            )
        )
    }
}

