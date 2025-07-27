//
//  BrakeTextFieldView_ex.swift
//  SharedDesignSystemExample
//
//  Created by Derrick kim on 7/27/25.
//

import SwiftUI
import SharedDesignSystem

struct BrakeTextFieldView_ex: View {
    @State private var groupName = "그룹명"
    @State private var nickname1 = "카피바라"
    @State private var nickname2 = "카피바라awxs&^%|"
    @State private var nickname3 = "카피바라짱짱"
    
    // 한글과 영문만 허용하는 정규식
    private let koreanEnglishRegex = "^[가-힣a-zA-Z]+$"
    
    var body: some View {
        VStack(spacing: 30) {

            VStack(spacing: 20) {
                Text("그룹명 입력 (상단 Description)")
                    .font(.subheadline)
                    .foregroundStyle(Colors.grey700.swiftUIColor)
                
                BrakeTextFieldView(
                    text: $groupName,
                    placeholder: "ex) SNS",
                    maxLength: 10,
                    regex: koreanEnglishRegex,
                    topDescription: "그룹명",
                    descriptionPosition: .top
                )
            }
            
            VStack(spacing: 20) {
                Text("유효한 닉네임 (하단 Description)")
                    .font(.subheadline)
                    .foregroundStyle(Colors.grey700.swiftUIColor)
                
                BrakeTextFieldView(
                    text: $nickname1,
                    placeholder: "닉네임을 입력하세요",
                    maxLength: 10,
                    regex: koreanEnglishRegex,
                    bottomDescription: "사용 가능한 닉네임입니다.",
                    descriptionPosition: .bottom
                )
            }
            
            VStack(spacing: 20) {
                Text("유효하지 않은 닉네임 (하단 Description)")
                    .font(.subheadline)
                    .foregroundStyle(Colors.grey700.swiftUIColor)
                
                BrakeTextFieldView(
                    text: $nickname2,
                    placeholder: "닉네임을 입력하세요",
                    maxLength: 10,
                    regex: koreanEnglishRegex,
                    bottomDescription: "Help Text",
                    descriptionPosition: .bottom
                )
            }
            
            VStack(spacing: 20) {
                Text("성공 상태 닉네임 (하단 Description)")
                    .font(.subheadline)
                    .foregroundStyle(Colors.grey700.swiftUIColor)
                
                BrakeTextFieldView(
                    text: $nickname3,
                    placeholder: "닉네임을 입력하세요",
                    maxLength: 10,
                    regex: koreanEnglishRegex,
                    bottomDescription: "사용 가능한 닉네임입니다.",
                    descriptionPosition: .bottom
                )
            }
            
            VStack(spacing: 20) {
                Text("Description 없는 텍스트 필드")
                    .font(.subheadline)
                    .foregroundStyle(Colors.grey700.swiftUIColor)
                
                BrakeTextFieldView(
                    text: .constant(""),
                    placeholder: "설명 없는 텍스트 필드",
                    maxLength: 20,
                    descriptionPosition: .none
                )
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("BrakeTextFieldView Example")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BrakeTextFieldView_ex()
    }
} 
