//
//  AppGroupMainView.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/27/25.
//

import SwiftUI
import Domain
import SharedDesignSystem


public struct AppGroupMainView: View {
    
    @Environment(AppGroupMainViewModel.self) var appGroupMainViewModel
    @State var addGroupPresent = false
    public init() { }
    
    public var body: some View {
        ZStack {
            Color.grey900.ignoresSafeArea(.all)
            if appGroupMainViewModel.appGroups.isEmpty {
                VStack {
                    VStack(spacing: 24) {
                        VStack(spacing: 10) {
                            Text("스크린타임, 이제 줄여볼까요?")
                                .font(.pretendard(size: 22, type: .semiBold))
                                .foregroundStyle(Color.grey00)
                            Text("사용을 자제할 앱을 추가해주세요.")
                                .font(.pretendard(size: 16, type: .medium))
                                .foregroundStyle(Color.grey200)
                        }
                        Button {
                            appGroupMainViewModel.addButtonTapped()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus")
                                Text("추가")
                            }
                            .tint(.grey800)
                            .font(.pretendard(size: 16, type: .bold))
                            .padding(.horizontal, 18.5)
                            .padding(.vertical, 10.5)
                            .background(Color.brakeYellow)
                            .cornerRadius(16)
                        }
                    }
                }
            } else {
                
            }

            
        }
        
        .fullScreenCover(
            isPresented:
                Binding(
                get: { appGroupMainViewModel.addGroupPresent },
                set: { appGroupMainViewModel.addGroupPresent = $0 }
            )
        ) {
            NavigationStack {
                AddAppGroupView()
                    .environment(
                        AddAppGroupViewModel(
                            createAppGroupUseCase: CreateAppGroupUseCase()
                        )
                    )
            }
        }
        
    }
}
