//
//  SetNicknameView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import SwiftUI

public struct SetNicknameView: View {
    @Environment(StartUpViewModel.self) var startUpViewModel
    @Environment(SetNicknameViewModel.self) var setNicknameViewModel
    
    @FocusState var nickNmaeFocusState: Bool
    
    public init() { }
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
                    TextField(
                        "닉네임을 입력해 주세요",
                        text: Binding(
                            get: { setNicknameViewModel.nickname },
                            set: { setNicknameViewModel.nickname = $0 }
                        )
                    )
                    .focused($nickNmaeFocusState)
                    .onChange(of: setNicknameViewModel.nickname) { oldValue, newValue in
                        setNicknameViewModel.validNickname(newValue)
                    }
                    HStack {
                        if !setNicknameViewModel.isValid && !setNicknameViewModel.nickname.isEmpty {
                            Text("공백, 특수문자 없이 2~10자를 입력해 주세요.")
                        }
                        Spacer()
                        Text("\(setNicknameViewModel.nickname.count)/10")
                    }
                }
                
                Spacer()
                Button {
                    self.setNicknameViewModel.nicknameCompletedBtnTapped()
                } label: {
                    Text("다음")
                }
                .disabled(!setNicknameViewModel.isValid)
            }
        }
    }
}


#Preview {
    SetNicknameView()
}
