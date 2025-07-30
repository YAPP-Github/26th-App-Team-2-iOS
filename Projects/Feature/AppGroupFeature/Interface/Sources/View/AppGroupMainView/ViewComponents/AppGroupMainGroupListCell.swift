//
//  AppGroupMainGroupListCell.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/30/25.
//

import Foundation
import SwiftUI
import SharedDesignSystem
import Domain

extension AppGroupMainView {
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
