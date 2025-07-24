//
//  LoginView.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/22/25.
//
import SwiftUI
import Domain
import WebKit
public struct LoginView: View {
    
    @Environment(LogInViewModel.self) var logInViewModel
    @State private var wkURL: URL? = URL(string: "https://www.naver.com")
    @State private var shouldShowWebView: Bool = false
    public init() { }
    
    public var body: some View {
        VStack(spacing: 16) {
            Button {
                logInViewModel.appleLogInBtnTapped()
            } label: {
                Text("Apple로 로그인")
            }
            
            Button {
                logInViewModel.kakaoLogInBtnTapped()
            } label: {
                Text("카카오로 로그인")
            }
            
            Button {
                wkURL = URL(string: "https://www.naver.com")
                
                shouldShowWebView = true
            } label: {
                Text("개인정보처리방침")
            }
            
            Button {
                wkURL = URL(string: "https://www.naver.com")
                shouldShowWebView = true
            } label: {
                Text("이용약관")
            }
        }.fullScreenCover(isPresented: $shouldShowWebView) {
            NavigationView {
                if let url = wkURL {
                    WebView(url: url)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("약관")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(trailing: Button("닫기") {
                            shouldShowWebView = false
                        })
                } else {
                    Text("잘못된 URL입니다")
                        .navigationTitle("오류")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(trailing: Button("닫기") {
                            shouldShowWebView = false
                        })
                }
            }
        }
    }
}



#Preview {
    LoginView()
        .environment(
            LogInViewModel(
                appleLogInUseCase: OAuthLogInUseCase(oAuthService: AppleLogInService.make()),
                kakaoLogInUseCase: OAuthLogInUseCase(oAuthService: KakaoLogInService.make())
            )
        )
}
