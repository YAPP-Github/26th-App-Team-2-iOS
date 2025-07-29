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
            VStack {
                Text("등록한 앱을 사용할 때\n사용 시간을 설정할 수 있어요")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.grey100)
                    .font(.pretendard(size: 20, type: .semiBold))
                VStack {
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
                }.padding(.horizontal, 16)
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
            .background(Color.grey700)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
