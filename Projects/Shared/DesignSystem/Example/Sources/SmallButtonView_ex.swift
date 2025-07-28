//
//  SmallButtonView_ex.swift
//  SharedDesignSystemExample
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI
import SharedDesignSystem

struct SmallButtonView_ex: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("SmallButtonView Examples")
                .font(.headline)
                .padding(.top)

            SmallButtonView(
                title: "활성화된 버튼",
                isActive: true) {
                    print("활성화된 버튼 클릭됨")
                }

            SmallButtonView(
                title: "비활성화된 버튼",
                isActive: false) {
                    print("비활성화된 버튼 클릭됨")
                }
        }
        .padding()
        .navigationTitle("SmallButtonView Example")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SmallButtonView_ex()
    }
}
