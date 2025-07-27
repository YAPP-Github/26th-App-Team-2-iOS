//
//  LargeButtonView_ex.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI
import SharedDesignSystem

struct LargeButtonView_ex: View {
    var body: some View {
        VStack {
            LargeButtonView(
                buttonTitle: "활성화된 버튼",
                isActive: true,
                height: 56) {
                    print("활성화된 버튼 클릭됨")
                }

            LargeButtonView(
                buttonTitle: "비활성화된 버튼",
                isActive: false,
                height: 56) {
                    print("비활성화된 버튼 클릭됨")
                }
        }
        .padding([.leading, .trailing], 16)
    }
}

#Preview {
    LargeButtonView_ex()
}
