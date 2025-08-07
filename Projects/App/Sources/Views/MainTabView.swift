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
    @State private var selectedTab: TabItemType = .dashboard
    @Environment(StartUpViewModel.self) var startUpViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.grey900
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    switch selectedTab {
                    case .report:
                        Color.clear
                    case .dashboard:
                        AppGroupMainView()
                            .environment(
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
                    case .myInfo:
                        MyInfoSettingView()
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

                    Spacer()

                    VStack {
                        BrakeTabBarView(selectedTabBarItem: .init(get: {
                            selectedTab
                        }, set: { item in
                            selectedTab = item
                        }))
                        .padding(.bottom, 16)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
