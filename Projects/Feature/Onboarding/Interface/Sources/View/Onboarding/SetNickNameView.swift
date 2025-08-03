//
//  SetNicknameView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/26/25.
//

import SwiftUI
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
                .contentShape(Rectangle())
                .onTapGesture { nickNmaeFocusState = false }
            VStack(spacing: 0) {
                @Bindable var viewModel = setNicknameViewModel
                BrakeNavigationView(title: {
                    EmptyView()
                }, leading: {
                    BrakeNavigationButton(type: .back) {
                        self.setNicknameViewModel.backButtonTapped()
                    }
                })
                .brakePopUp(
                    isPresented: $viewModel.resetLogInPresent,
                    title: "로그인을 취소하시겠어요?",
                    message: "계정 정보는 모두 사라집니다.",
                    alertType: .doubleButton,
                    primaryButtonTitle: "확인",
                    secondaryButtonTitle: "취소",
                    primaryAction: {
                        viewModel.resetLogInPresent = false
                        viewModel.confirmDeleteUserButtonTapped()
                    },
                    secondaryAction: {
                    viewModel.resetLogInPresent = false
                })
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("어떻게 불러드릴까요?")
                            .font(.pretendard(size: 24, type: .bold))
                            .foregroundStyle(Color.white)
                            .frame(height: 36)
                        Text("나중에 변경할 수 있어요")
                            .font(.pretendard(size: 16, type: .medium))
                            .foregroundStyle(Color.grey400)
                            .frame(height: 24)
                    }
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
                VStack(spacing: 8) {
                    ZStack(alignment: .trailing) {
                        BrakeTextFieldView(
                            text: $viewModel.nickname,
                            placeholder: "닉네임을 입력해주세요.",
                            backgroundColor: .grey850,
                            textColor: .grey200,
                            placeholderColor: .grey700,
                            cornerRadius: 16
                        )
                        .autocorrectionDisabled()
                        .focused($nickNmaeFocusState)

                        if viewModel.isValid {
                            Image.iconCheckGreen
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 16)
                        }
                    }
                    .padding(.horizontal, 16)
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
                    .padding(.horizontal, 32)
                    .font(.pretendard(size: 12, type: .medium))
                    .foregroundStyle( {
                        if !setNicknameViewModel.isValid && !setNicknameViewModel.nickname.isEmpty {
                            Color.error
                        } else if !setNicknameViewModel.nickname.isEmpty {
                            Color.guideGreen
                        } else {
                            Color.brakeWhite
                        }
                    }())
                }
                .padding(.top, 38)
                Spacer()
            }
            .onTapGesture {
                nickNmaeFocusState = false
            }
            LargeButtonView(
                buttonType: .confirm,
                title: "다음",
                isActive: setNicknameViewModel.isValid) {
                    self.setNicknameViewModel.nicknameCompletedBtnTapped()
                }
                .padding(.bottom, 16)
        }
    }
}


#Preview {
    SetNicknameView()
}
