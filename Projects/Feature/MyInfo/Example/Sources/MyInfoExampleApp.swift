//
//  MyInfoExampleApp.swift
//  FeatureMyInfo
//
//  Created by Assistant on 8/2/25.
//

import SwiftUI
import FeatureMyInfoInterface
import SharedUtil
import Domain
import SharedDesignSystem

@main
struct MyInfoExampleApp: App {
    
    @Environment(\.diContainer) var diContainer
    @State private var selectedTab: TabItemType = .myInfo
    @State var isTabBarHidden: Bool = false

    init() { }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // 선택된 탭에 따라 다른 색상의 배경
                switch selectedTab {
                case .report:
                    Color.brakeYellowDark
                        .ignoresSafeArea()
                case .dashboard:
                    Color.insightBlue
                        .ignoresSafeArea()
                case .myInfo:
                    Color.grey900
                        .ignoresSafeArea()
                }
                
                VStack(spacing: 0) {
                    // 탭별 컨텐츠
                    switch selectedTab {
                    case .report:
                        Color.clear // 리포트 탭 컨텐츠
                    case .dashboard:
                        Color.clear // 대시보드 탭 컨텐츠
                    case .myInfo:
                        MyInfoSettingView(isTabBarHidden: $isTabBarHidden)
                            .environment(
                                MyInfoSettingViewModel(
                                    fetchUserNicknameUseCase: diContainer.fetchUserNicknameUseCase,
                                    userSetNicknameUseCase: diContainer.userSetNicknameUseCase,
                                    deleteUserUseCase: diContainer.deleteUserUseCase,
                                    oAuthLogoutUseCase: diContainer.oAuthLogoutUseCase
                                )
                            )
                    }
                    
                    Spacer()
                    
                    // 하단 탭바
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
    }
} 
