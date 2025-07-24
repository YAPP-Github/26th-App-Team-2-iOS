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
    @State private var kakaoLogInShow: Bool = false
    @State private var loading: Bool = false
    
    public init() { }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Button {
                    logInViewModel.appleLogInBtnTapped()
                } label: {
                    Text("Apple로 로그인")
                }
                Button {
                    logInViewModel.kakaoLogInBtnTapped()
                    self.kakaoLogInShow.toggle()
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
            })
        .fullScreenCover(isPresented: $shouldShowWebView) {
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




