//
//  BrakeToastView_ex.swift
//  SharedDesignSystemExample
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI
import SharedDesignSystem

struct BrakeToastView_ex: View {
    @State private var showToast = false
    @State private var toastMessage = "성공적으로 저장되었습니다"
    var body: some View {
        VStack(spacing: 30) {
            Text("BrakeToastView Examples")
                .font(.headline)
                .foregroundStyle(Color.white)
            
            // 메시지 입력
            VStack(spacing: 15) {
                Text("메시지 입력")
                    .font(.subheadline)
                    .foregroundStyle(Color.grey700)
                
                BrakeTextFieldView(
                    text: $toastMessage,
                    placeholder: "토스트 메시지를 입력하세요"
                )
            }
            
            // 토스트 표시 버튼
            Button("토스트 표시") {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showToast = false
                    }
                }
            }
            .font(.pretendard(size: 16, type: .semiBold))
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.insightBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            

            // 토스트 미리보기
            VStack(spacing: 15) {
                Text("토스트 미리보기")
                    .font(.subheadline)
                    .foregroundStyle(Color.grey700)
                
                BrakeToastView(
                    message: toastMessage
                )
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black)
        .navigationTitle("BrakeToastView Example")
        .navigationBarTitleDisplayMode(.inline)
        .toast(show: showToast)
    }
}



#Preview {
    NavigationStack {
        BrakeToastView_ex()
    }
} 
