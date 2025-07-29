//
//  AddAppGroupListEmptyView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 7/29/25.
//

import SwiftUI
import SharedDesignSystem

extension UpsertAppGroupView {
    struct UpsertAppGroupListEmptyView: View {
        @Environment(UpsertAppGroupViewModel.self) var addAppGroupViewModel
        var body: some View {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.grey850)
                .overlay {
                    VStack(spacing: 28) {
                        Text("사용을 자제할\n앱을 선택해주세요")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.brakeWhite)
                            .font(.pretendard(size: 18, type: .semiBold))
                        Button {
                            addAppGroupViewModel.selectionBtnTapped()
                        } label: {
                            Circle().fill(Color.brakeYellow)
                                .overlay {
                                    Image(systemName: "plus")
                                        .font(.pretendard(size: 14, type: .semiBold))
                                        .foregroundStyle(Color.brakeDark)
                                }
                                .frame(width: 52, height: 52)
                        }
                    }
                }
        }
    }
}
