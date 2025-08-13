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
    @Environment(MainAppViewModel.self) var mainAppViewModel
    @Environment(\.scenePhase) var scenePhase
    
    @State private var selectedTab: TabItemType = .dashboard
    @State var appGroupMainViewModel: AppGroupMainViewModel?
    @State var myInfoSettingViewModel: MyInfoSettingViewModel?
    
    var body: some View {
        BrakeTabView(
            selectedTab: $selectedTab
        ) { selectedTab in
            ZStack {
                Color.grey900.ignoresSafeArea()
                switch selectedTab {
                case .dashboard:
                    if let appGroupMainViewModel {
                        AppGroupMainView()
                            .environment(appGroupMainViewModel)
                    } else {
                        nilViewModelErrorView
                    }
                    
                case .myInfo:
                    if let myInfoSettingViewModel {
                        MyInfoSettingView()
                            .environment(myInfoSettingViewModel)
                    } else {
                        nilViewModelErrorView
                    }
                }
            }
            .animation(.default, value: selectedTab)
        }
        .environment(appGroupMainViewModel)
        .environment(myInfoSettingViewModel)
        .onAppear() {
            mainAppViewModel.onAppear()
            self.myInfoSettingViewModel = MyInfoSettingViewModel(
                fetchUserNicknameUseCase: appDIContainer.useCaseContainer.fetchUserNicknameUseCase,
                userSetNicknameUseCase: appDIContainer.useCaseContainer.userSetNicknameUseCase,
                deleteUserUseCase: appDIContainer.useCaseContainer.deleteUserUseCase,
                oAuthLogoutUseCase: appDIContainer.useCaseContainer.oAuthLogoutUseCase,
                onLogout: {
                    startUpViewModel.logout()
                }
            )
            self.appGroupMainViewModel = AppGroupMainViewModel(
                fetchAppGroupUseCase: appDIContainer.useCaseContainer.fetchAppGroupUseCase,
                fetchSelectedNotificationUseCase: appDIContainer.useCaseContainer.fetchSelectedNotificationUseCase,
                createBlockScheduleUseCase: appDIContainer.useCaseContainer.createBlockScheduleUseCase,
                deleteBlockScheduleUseCase: appDIContainer.useCaseContainer.deleteBlockScheduleUseCase,
                fetchBlockScheduleUseCase: appDIContainer.useCaseContainer.fetchBlockScheduleUseCase,
                endBlockScheduleUseCase: appDIContainer.useCaseContainer.endBlockScheduleUseCase,
                getBlockingStatusUseCase: appDIContainer.useCaseContainer.getBlockingStatusUseCase,
                endBreakTimeUseCase: appDIContainer.useCaseContainer.endBreakTimeUseCase
            )
        }
        .onChange(of: scenePhase, { oldValue, newValue in
            if newValue == .active {
                mainAppViewModel.sceneActive()
            }
        })
        .environment(mainAppViewModel)
        .mainAuthModifier()
        
    }
    @ViewBuilder var nilViewModelErrorView: some View {
        ZStack {
            Color.grey900.ignoresSafeArea()
                .brakePopUp(
                    isPresented: .constant(true),
                    title: "일시적인 오류가 발생했어요.",
                    message: "나중에 다시 시도해주세요.",
                    primaryButtonTitle: "확인",
                    primaryAction: {
                        
                    }
                )
        }
    }
}

fileprivate extension View {
    func mainAuthModifier() -> some View {
        return self.modifier(MainAuthModifier())
    }
}


