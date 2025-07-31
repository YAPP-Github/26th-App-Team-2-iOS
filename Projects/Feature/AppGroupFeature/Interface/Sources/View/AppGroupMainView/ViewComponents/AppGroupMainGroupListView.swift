//
//  AppGroupMainGroupListView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 7/29/25.
//

import SwiftUI
import SharedDesignSystem
import Domain

extension AppGroupMainView {
    struct AppGroupMainGroupListView: View {
        @Environment(AppGroupMainViewModel.self) private var appGroupMainViewModel
        var body: some View {
            VStack(spacing: 0) {
                Color.grey900.frame(height: 1)
                GeometryReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            VStack(spacing: 24) {
                                Image.appGroup.mainFull
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Rectangle())
                                    .frame(width: proxy.size.width)
                                    .overlay(alignment: .bottom) {
                                        LinearGradient(
                                            stops: [
                                                .init(color: Color.grey900.opacity(1), location: 0),
                                                .init(color: Color.grey900.opacity(1), location: 0.1),
                                                .init(color: Color.grey900.opacity(0.7), location: 0.27),
                                                .init(color: .clear, location: 1)
                                            ],
                                            startPoint: .bottom,
                                            endPoint: .top
                                        )
                                        .frame(height: proxy.size.height * 0.25)
                                    }
                                VStack(spacing: 6) {
                                    Text("등록한 앱을 사용할 때")
                                    Text("사용 시간을 설정할 수 있어요")
                                }
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.grey100)
                                .font(.pretendard(size: 20, type: .semiBold))
                                .padding(.bottom, 24)
                            }
                            .frame(height: proxy.size.height / 2)
                            VStack(spacing: 16) {
                                HStack(alignment: .bottom) {
                                    Text("그룹")
                                        .foregroundStyle(Color.grey00)
                                        .font(.pretendard(size: 22, type: .semiBold))
                                    Spacer()
                                    Text("\(appGroupMainViewModel.appGroups.count)개")
                                        .foregroundStyle(Color.grey200)
                                        .font(.pretendard(size: 12, type: .medium))
                                }.padding(.horizontal, 16)
                                VStack {
                                    ForEach(appGroupMainViewModel.appGroups, id: \.groupID) { appGroup in
                                        AppGroupListCell(appGroup: appGroup) {
                                            appGroupMainViewModel.editButtonTapped(appGroup: appGroup)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
    }
}
