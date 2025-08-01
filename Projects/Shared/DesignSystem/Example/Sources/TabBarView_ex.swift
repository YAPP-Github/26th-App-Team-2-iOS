//
//  BrakeTabBarView_ex.swift
//  SharedDesignSystemExample
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI
import SharedDesignSystem

struct BrakeTabBarView_ex: View {
    @State private var selectedTab: TabItemType = .report
    
    var body: some View {
        BrakeTabView(selectedTab: $selectedTab) { selectedTab in
            VStack(spacing: 0) {
                // 상단 컨텐츠 영역
                // 선택된 탭에 따라 다른 색상의 배경
                ZStack {
                    switch selectedTab {
                    case .report:
                        Color.brakeYellowDark
                            .ignoresSafeArea()
                    case .dashboard:
                        Color.insightBlue
                            .ignoresSafeArea()
                    case .myInfo:
                        Color.guideGreen
                            .ignoresSafeArea()
                    }
                    
                    VStack(spacing: 20) {
                        Text("현재 선택된 탭")
                            .font(.pretendard(size: 24, type: .bold))
                            .foregroundStyle(Color.brakeWhite)
                        
                        Text(selectedTab.title)
                            .font(.pretendard(size: 32, type: .extraBold))
                            .foregroundStyle(Color.brakeWhite)
                        
                        Text("탭을 클릭하여 다른 뷰로 전환해보세요")
                            .font(.pretendard(size: 16, type: .medium))
                            .foregroundStyle(Color.brakeWhite)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
            }
            .navigationTitle("TabBar Example")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}


