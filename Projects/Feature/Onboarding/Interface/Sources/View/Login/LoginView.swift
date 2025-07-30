//
//  LoginView.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/22/25.
//
import SwiftUI
import Domain
import WebKit
import SharedDesignSystem
public struct LoginView: View {
    @Environment(LogInViewModel.self) var logInViewModel
    @State private var wkURL: URL? = URL(string: "https://www.naver.com")
    @State private var shouldShowWebView: Bool = false
    @State private var kakaoLogInShow: Bool = false
    @State private var loading: Bool = false
    
    public init() { }
    
    public var body: some View {
        ZStack {
            Color.grey900.ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer()
                LoginFooterView {
                    logInViewModel.kakaoLogInBtnTapped()
                    self.kakaoLogInShow.toggle()
                } appleLogInButtonTapped: {
                    logInViewModel.appleLogInBtnTapped()
                } privacyInfoButtonTapped: {
                    wkURL = URL(string: "https://www.naver.com")
                    shouldShowWebView = true
                }
                .padding([.horizontal, .bottom], 16)
            }
            VStack(spacing: 8) {
                Text("계획한 만큼만 앱을 사용하도록\n도와드릴게요")
                    .font(.pretendard(size: 22, type: .semiBold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            
            if logInViewModel.loading {
                ProgressView()
            }
        }
        .sheet(
            isPresented: $kakaoLogInShow,
            content: {
                NavigationView {
                    KakaoWebView { onSuccess in
                        self.logInViewModel.kakaoCodeFetchSuccess(authorizationCode: onSuccess)
                        kakaoLogInShow.toggle()
                    } onAuthError: { error in
                        self.loading = false
                        kakaoLogInShow.toggle()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle("카카오 로그인")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing: Button("닫기") {
                        kakaoLogInShow = false
                    })
                }
            }
        )
        .fullScreenCover(isPresented: $shouldShowWebView) {
            NavigationView {
                if let url = wkURL {
                    WebView(url: url)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("약관")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(
                            trailing: Button("닫기") {
                                shouldShowWebView = false
                            }
                        )
                } else {
                    Text("잘못된 URL입니다")
                        .navigationTitle("오류")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(
                            trailing: Button("닫기") {
                                shouldShowWebView = false
                            }
                        )
                }
            }
        }
    }
    
}



