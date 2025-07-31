//
//  UpsertAppGroupFooterView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 7/30/25.
//

import SwiftUI
import SharedDesignSystem

extension UpsertAppGroupView {
    struct UpsertAppGroupFooterView: View {
        let groupDeleteActive: Bool
        let groupDeleteAction: () -> ()
        let confirmActive: Bool
        let confirmAction: () -> ()
        var body: some View {
            VStack(spacing: 22) {
                if groupDeleteActive {
                    Button {
                        groupDeleteAction()
                    } label: {
                        HStack(spacing: 1.5) {
                            Image.iconTrash
                            Text("그룹 삭제")
                                .font(.pretendard(size: 14, type: .medium))
                                .foregroundStyle(Color.grey300)
                                .underline()
                        }
                    }
                }
                
                LargeButtonView(
                    buttonType: .confirm,
                    title: "완료",
                    isActive: confirmActive
                ) {
                    confirmAction()
                }
                .padding(.horizontal, 16)
            }
        }
    }
}


