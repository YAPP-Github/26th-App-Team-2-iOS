//
//  FooterView.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/30/25.
//

import SwiftUI
import SharedDesignSystem

extension LoginView {
    struct LoginFooterView: View {
        let kakaoLogInButtonTapped: () -> ()
        let appleLogInButtonTapped: () -> ()
        let privacyInfoButtonTapped: () -> ()
        var body: some View {
            VStack(spacing: 25) {
                VStack(spacing: 0) {
                    Text("아래 버튼으로 로그인 시,")
                    TappableText(
                        text: "개인정보처리방침 및 이용약관에 동의하는 것으로 간주합니다.",
                        tappableWords: [
                            "개인정보처리방침": {
                                privacyInfoButtonTapped()
                            },
                            "이용약관" : {
                                privacyInfoButtonTapped()
                            }
                        ])
                }
                .font(.pretendard(size: 12, type: .medium))
                .foregroundStyle(Color.grey400)
                VStack(spacing: 12) {
                    loginButton(icon: .iconApple, title: "Apple로 로그인", bgColor: .white) {
                        appleLogInButtonTapped()
                    }
                    loginButton(icon: .iconKakao, title: "카카오로 로그인", bgColor: .kakaoYellow) {
                        kakaoLogInButtonTapped()
                    }
                }
            }
        }
        
        
        @ViewBuilder func loginButton(
            icon: Image,
            title: String,
            bgColor: Color,
            tapAction: @escaping () -> Void
        ) -> some View {
            Button  {
                tapAction()
            } label: {
                HStack {
                    icon
                    HStack {
                        Spacer()
                        Text(title)
                            .font(.pretendard(size: 16, type: .bold))
                            .foregroundStyle(Color.grey900)
                        Spacer()
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background(bgColor)
                .cornerRadius(16)
            }
        }
    }
    
    
}


