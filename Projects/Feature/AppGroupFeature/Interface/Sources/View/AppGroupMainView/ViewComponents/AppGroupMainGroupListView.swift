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
        @Environment(AppGroupMainViewModel.self) var appGroupMainViewModel
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
                    .task {
                        print("프록시 사이즈: \(proxy.size)")
                    }
                }
            }
        }
    }
    
    struct AppGroupListCell: View {
        let appGroup: AppGroup
        let editButtonTapped: () -> ()
        var body: some View {
            VStack(spacing: 12) {
                HStack {
                    HStack {
                        Image.iconGroup
                        Text(appGroup.name)
                            .font(.pretendard(size: 16, type: .medium))
                    }
                    .foregroundStyle(Color.grey00)
                    Spacer()
                    Button {
                        editButtonTapped()
                    } label: {
                        Image.iconCircleEdit
                    }
                }
                HStack(spacing: 0) {
                    let allApplicationTokensCount = appGroup.selection.applicationTokens.count
                    let infoApplicationTokens = appGroup.selection.applicationTokens.map { $0 }.prefix(6)
                    ForEach(infoApplicationTokens, id: \.hashValue) { applicationToken in
                        Label(applicationToken)
                            .labelStyle(.iconOnly)
                            .scaleEffect(1.2)
                    }
                    
                    if allApplicationTokensCount > 6 {
                        let restCount = allApplicationTokensCount - 6
                        Text("+\(restCount)")
                            .font(.pretendard(size: 14, type: .medium))
                            .foregroundStyle(Color.grey200)
                    }
                    Spacer()
                }.padding(.leading, 8)
            }
            .padding([.top, .horizontal], 16)
            .padding(.bottom, 24)
            .background {
                LinearGradient(
                    colors: [
                        Color(hex: "#292C31"),
                        Color(hex: "#32363B")
                    ],
                    startPoint: UnitPoint(x: 0.4, y: 0),
                    endPoint: UnitPoint(x: 0.6,y: 1)
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
