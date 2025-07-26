//
//  SetNickNameView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import SwiftUI



public struct SetNickNameView: View {
    @State private var nickName: String = ""
    @State private var isValid: Bool = false
    @State private var nickNameCompleted: Bool = false
    
    @FocusState var nickNmaeFocusState: Bool
    
    public init() {
    }
    public var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    nickNmaeFocusState = false
                }
            VStack {
                Spacer()
                VStack {
                    TextField("닉네임을 입력해 주세요", text: $nickName)
                        .focused($nickNmaeFocusState)
                        .onChange(of: nickName) { oldValue, newValue in
                            // 10자 초과 시 잘라내기
                            if newValue.count > 10 {
                                nickName = String(newValue.prefix(10))
                            }
                            // 모든 언어의 문자, 숫자만 허용 (공백, 특수문자 불가)
                            let regex = "^[\\p{L}\\p{N}]{2,10}$"
                            if let _ = newValue.range(of: regex, options: [.regularExpression]) {
                                isValid = true
                            } else {
                                isValid = false
                            }
                        }
                    HStack {
                        if !isValid && !nickName.isEmpty {
                            Text("공백, 특수문자 없이 2~10자를 입력해 주세요.")
                        }
                        Spacer()
                        Text("\(nickName.count)/10")
                    }
                }
                
                Spacer()
                
                Button {
                    nickNameCompleted = true
                } label: {
                    Text("다음")
                }
                .disabled(!isValid)
            }
        }
        .navigationDestination(isPresented: $nickNameCompleted) {
            OnboardingInfoView()
        }
    }
}


#Preview {
    SetNickNameView()
}
