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
    @State private var kakaoLogInShow: Bool = false
    @State private var loading: Bool = false
    
    public init() { }
    
    public var body: some View {
        @Bindable var viewModel = logInViewModel
        ZStack {
            Color.grey900.ignoresSafeArea()
            VStack {
                Image.onboarding.login
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
                Spacer()
            }
            VStack(spacing: 16) {
                Spacer()
                LoginFooterView {
                    logInViewModel.kakaoLogInBtnTapped()
                    self.kakaoLogInShow.toggle()
                } appleLogInButtonTapped: {
                    logInViewModel.appleLogInBtnTapped()
                } privacyInfoButtonTapped: {
                    self.logInViewModel.privacyInfoButtonTapped()
                } termsOfServiceButtonTapped: {
                    self.logInViewModel.termsOfServiceButtonTapped()
                }
                .padding([.horizontal, .bottom], 16)
            }
            VStack(alignment: .center, spacing: 0) {
                Text("계획한 만큼만 앱을 사용하도록").frame(height: 33)
                Text("도와드릴게요")
                    .frame(height: 33)
            }
            .font(.pretendard(size: 22, type: .semiBold))
            .foregroundStyle(.white)
            
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
        .fullScreenCover(
            item: $viewModel.linkInfoItem,
            content: { linkInfoItem in
            NavigationView {
                if let url = URL(string: linkInfoItem.url) {
                    BrakeWebView(url: url)
                    .ignoresSafeArea(.container, edges: .bottom)
                    .navigationTitle(linkInfoItem.title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("완료") {  viewModel.webCompletedButtonTapped() }
                        }
                    }
                } else {
                    Text("잘못된 URL입니다")
                        .navigationTitle("오류")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("완료") { viewModel.webCompletedButtonTapped() }
                            }
                        }
                }
            }
        })
    }
}




