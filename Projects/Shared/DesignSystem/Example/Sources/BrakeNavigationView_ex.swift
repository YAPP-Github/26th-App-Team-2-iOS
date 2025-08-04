//
//  BrakeNavigationView_ex.swift
//  SharedDesignSystemExample
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI
import SharedDesignSystem

struct BrakeNavigationView_ex: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 20) {
                BrakeNavigationView {
                    Text("타이틀")
                    .font(.pretendard(size: 18, type: .semiBold))
                    .foregroundStyle(Color.brakeWhite)
                } leading: {
                    BrakeNavigationButton(type: .back) {
                        alertMessage = "뒤로가기 버튼이 클릭되었습니다"
                        showAlert = true
                    }
                } trailing: {
                    BrakeNavigationButton(type: .edit) {
                        alertMessage = "닫기 버튼이 클릭되었습니다"
                        showAlert = true
                    }
                }
            }
        }
        .padding()
        .navigationTitle("BrakeNavigationView Example")
        .navigationBarTitleDisplayMode(.inline)
        .alert("알림", isPresented: $showAlert) {
            Button("확인") { }
        } message: {
            Text(alertMessage)
        }
    }
}



#Preview {
    NavigationStack {
        BrakeNavigationView_ex()
    }
}
