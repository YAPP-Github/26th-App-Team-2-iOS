//
//  SetNicknameView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import SwiftUI
import SharedDesignSystem
import SharedDesignSystem

public struct SetNicknameView: View {
    @Environment(StartUpViewModel.self) var startUpViewModel
    @Environment(SetNicknameViewModel.self) var setNicknameViewModel
    
    
    @FocusState var nickNmaeFocusState: Bool
    
    public init() { }
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.grey900
                .ignoresSafeArea()
        ZStack(alignment: .bottom) {
            Color.grey900
                .ignoresSafeArea()
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
                        } else if !setNicknameViewModel.nickname.isEmpty {
                            Text("사용 가능한 닉네임입니다.")
                        }
                        Spacer()
                        Text("\(setNicknameViewModel.nickname.count)/10")
                    }
                }
                
                Spacer()
                Button {
                    self.setNicknameViewModel.nicknameCompletedBtnTapped()
                }
                .padding(.bottom, 16)
        }
    }
}


#Preview {
    SetNicknameView()
}
