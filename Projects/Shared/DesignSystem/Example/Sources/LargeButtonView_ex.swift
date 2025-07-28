//
//  LargeButtonView_ex.swift
//  SharedDesignSystemExample
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI
import SharedDesignSystem

struct LargeButtonView_ex: View {
    @State private var isActive = true
    
    var body: some View {
        VStack(spacing: 20) {
            Text("LargeButtonView Examples")
                .font(.headline)
                .padding(.top)
            
            LargeButtonView(
                title: "활성화된 버튼",
                isActive: true,
                height: 56) {
                    print("활성화된 버튼 클릭됨")
                }
            
            LargeButtonView(
                title: "비활성화된 버튼",
                isActive: false,
                height: 56) {
                    print("비활성화된 버튼 클릭됨")
                }
            
            Toggle("버튼 활성화/비활성화", isOn: $isActive)
                .padding(.horizontal)
            
            LargeButtonView(
                title: "토글 버튼",
                isActive: isActive,
                height: 56) {
                    print("토글 버튼 클릭됨")
                }
            
            Spacer()
            VStack {
                LargeButtonView(
                    buttonType: .confirm,
                    title: "Confirm 버튼",
                    isActive: true
                ) {
                    print("Confirm 버튼이 활성화 됨!!")
                }
            }
        }
        .padding()
        .navigationTitle("LargeButtonView Example")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LargeButtonView_ex()
    }
}
