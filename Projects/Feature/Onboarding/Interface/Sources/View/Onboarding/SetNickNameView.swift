//
//  SetNickNameView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import SwiftUI

public struct SetNickNameView: View {
    @Environment(StartUpViewModel.self) var startUpViewModel
    @Environment(SetNickNameViewModel.self) var setNickNameViewModel
    
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
                            get: { setNickNameViewModel.nickName },
                            set: { setNickNameViewModel.nickName = $0 }
                        )
                    )
                    .focused($nickNmaeFocusState)
                    .onChange(of: setNickNameViewModel.nickName) { oldValue, newValue in
                        setNickNameViewModel.validNickName(newValue)
                    }
                    HStack {
                        if !setNickNameViewModel.isValid && !setNickNameViewModel.nickName.isEmpty {
                            Text("공백, 특수문자 없이 2~10자를 입력해 주세요.")
                        }
                        Spacer()
                        Text("\(setNickNameViewModel.nickName.count)/10")
                    }
                }
                
                Spacer()
                Button {
                    self.setNickNameViewModel.nickNameCompletedBtnTapped()
                } label: {
                    Text("다음")
                }
                .disabled(!setNickNameViewModel.isValid)
            }
        }
    }
}


#Preview {
    SetNickNameView()
}
