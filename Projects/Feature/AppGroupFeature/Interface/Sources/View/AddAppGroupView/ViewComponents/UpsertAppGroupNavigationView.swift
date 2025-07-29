//
//  AddAppGroupNavigationView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 7/29/25.
//

import SwiftUI
import SharedDesignSystem

extension UpsertAppGroupView {
    struct UpsertAppGroupNavigationView: View {
        let isCreating: Bool
        let cancelCompletion: () -> Void
        var body: some View {
            BrakeNavigationView(
                title: Text(isCreating ? "앱 그룹 추가" : "앱 그룹 관리")
                    .foregroundStyle(Color.grey100)
                    .font(.pretendard(size: 16, type: .semiBold)),
                trailing: {
                    BrakeNavigationButton(type: .cancel) {
                        cancelCompletion()
                    }
                }
            )
        }
    }
}
