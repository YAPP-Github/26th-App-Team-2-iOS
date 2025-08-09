//
//  EditProfileView.swift
//  FeatureMyInfoInterface
//
//  Created by Derrick kim on 8/2/25.
//

import SwiftUI
import SharedDesignSystem

public struct EditProfileView: View {
    
    @Environment(MyInfoSettingViewModel.self) var viewModel
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var isTextFieldFocused: Bool
    
    private let maxLength: Int = 10
    @State private var isValid: Bool = false
    @State private var hasError: Bool = false
    @State private var tempNickname: String
    
    // 유효성 검사
    private var isNicknameValid: Bool {
        return tempNickname.isValidNickName
    }
    
    public init(nickname: String) {
        self._tempNickname = State(initialValue: nickname)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            BrakeNavigationView {
                Text("프로필 편집")
                    .font(.pretendard(size: 16, type: .semiBold))
                    .foregroundStyle(Color.grey100)
            } leading: {
                BrakeNavigationButton(type: .back) {
                    dismiss()
                }
            }
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(Color.grey850)
                                .frame(width: 100, height: 100)
                            
                            Image.iconProfile
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 86, height: 82)
                                .offset(y: 17)
                        }
                        .mask(Circle())
                        .padding(.top, 36)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("닉네임")
                                .font(.pretendard(size: 14, type: .medium))
                                .foregroundColor(.grey200)
                                .padding(.leading, 16)
                            
                            BrakeTextFieldView(
                                text: $tempNickname,
                                placeholder: "닉네임을 입력해주세요"
                            )
                            .focused($isTextFieldFocused)
                            .onChange(of: tempNickname) { oldValue, newValue in
                                // 10자 제한
                                if newValue.count > maxLength {
                                    tempNickname = String(newValue.prefix(maxLength))
                                }
                            }
                            
                            HStack {
                                Spacer()
                                
                                HStack(spacing: 0) {
                                    Text("\(tempNickname.count)")
                                        .font(.pretendard(size: 12, type: .medium))
                                        .foregroundStyle(isNicknameValid ? Color.brakeWhite : Color.error)
                                    
                                    Text("/")
                                        .font(.pretendard(size: 12, type: .medium))
                                        .foregroundStyle(isNicknameValid ? Color.brakeWhite : Color.error)
                                    
                                    Text("\(maxLength)")
                                        .font(.pretendard(size: 12, type: .medium))
                                        .foregroundStyle(isNicknameValid ? Color.grey400 : Color.error)
                                }
                                .padding(.trailing, 16)
                            }
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 32)
                        .padding(.bottom, 100) // 저장 버튼 공간 확보
                    }
                }
                .ignoresSafeArea(.keyboard)
                .background(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    isTextFieldFocused = false
                }
                
                Button {
                    Task {
                        do {
                            try await viewModel.editNickname(tempNickname)
                            // 성공 시에만 화면 닫기
                            await MainActor.run { dismiss() }
                        } catch {
                            await MainActor.run {
                                viewModel.toastMessage = "닉네임 변경에 실패했습니다"
                                viewModel.showToast = true
                                Task {
                                    try? await Task.sleep(for: .seconds(1.0))
                                    await MainActor.run {
                                        viewModel.showToast = false
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Text("저장")
                        .font(.pretendard(size: 16, type: .semiBold))
                        .foregroundColor(.grey900)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(isNicknameValid ? Color.buttonYellow : Color.grey700)
                        .cornerRadius(16)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                }
                .disabled(!isNicknameValid)
            }
        }
        .background(Color.grey900)
        .navigationBarHidden(true)
        .toast(message: viewModel.showToast ? viewModel.toastMessage : nil, bottomPadding: 20)
    }
}
