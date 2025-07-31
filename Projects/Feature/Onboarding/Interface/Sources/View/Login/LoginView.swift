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
    @State private var linkInfoItem: LinkInfoItem? = nil
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
                    self.linkInfoItem = LinkInfoItem(
                        title: "brake.site",
                        url: URL(string: Constants.WebURLLinks.privacyPolicy)
                        )
                } termsOfServiceButtonTapped: {
                    self.linkInfoItem = LinkInfoItem(
                        title: "brake.site",
                        url: URL(string: Constants.WebURLLinks.termsOfService)
                        )
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
        .fullScreenCover(item: self.$linkInfoItem, content: { linkInfoItem in
            NavigationView {
                if let url = linkInfoItem.url {
                    WebView(url: url)
                    .ignoresSafeArea(.container, edges: .bottom)
                    .navigationTitle(linkInfoItem.title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(content: {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("완료") { self.linkInfoItem = nil }
                        }
                    })
                } else {
                    Text("잘못된 URL입니다")
                        .navigationTitle("오류")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(content: {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("완료") { self.linkInfoItem = nil }
                            }
                        })
                }
            }
        })
    }
}

private struct LinkInfoItem: Identifiable {
    var id: String { title }
    let title: String
    let url: URL?
}


