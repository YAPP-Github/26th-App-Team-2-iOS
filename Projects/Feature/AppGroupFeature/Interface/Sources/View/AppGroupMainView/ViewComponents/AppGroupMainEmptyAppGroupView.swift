//
//  AppGroupMainEmptyAppGroupView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 7/29/25.
//

import SwiftUI
import SharedDesignSystem

extension AppGroupMainView {
    struct AppGroupMainEmptyAppGroupView: View {
        let addButtonTapped: () -> Void
        var body: some View {
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
                        addButtonTapped()
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
        }
    }
}
