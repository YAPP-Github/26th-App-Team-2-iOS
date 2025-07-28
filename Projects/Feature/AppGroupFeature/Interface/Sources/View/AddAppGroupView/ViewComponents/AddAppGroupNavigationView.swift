//
//  AddAppGroupNavigationView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 7/29/25.
//

import SwiftUI
import SharedDesignSystem

extension AddAppGroupView {
    struct AddAppGroupNavigationView: View {
        let cancelCompletion: () -> Void
        var body: some View {
            BrakeNavigationView(
                title: Text("앱 그룹 추가")
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
