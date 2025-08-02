//
//  LogInViewModel.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/22/25.
//

import Foundation
import Domain
import SharedUtil

struct LinkInfoItem: Identifiable {
    var id: String { title }
    let title: String
    let url: URL?
}


@Observable
public final class LogInViewModel {
    var linkInfoItem: LinkInfoItem?
    var kakaoLogInShow: Bool = false
    var loading: Bool = false
    
    private let appleLogInUseCase: AppleLogInUseCase
    private let kakaoLogInUseCase: KakaoLogInUseCase
    
    private let logInCompleted: () -> ()
    
    public init(
        appleLogInUseCase: AppleLogInUseCase,
        kakaoLogInUseCase: KakaoLogInUseCase,
        logInCompleted: @escaping () -> ()
    ) {
        self.appleLogInUseCase = appleLogInUseCase
        self.kakaoLogInUseCase = kakaoLogInUseCase
        self.logInCompleted = logInCompleted
    }
    
    @MainActor
    func appleLogInBtnTapped() {
        self.loading = true
        Task {
            do {
                try await self.appleLogInUseCase.execute()
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.loading = false
                    logInCompleted()
                }
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.loading = false
                }
            }
        }
    }
    
    @MainActor
    func kakaoLogInBtnTapped() {
        self.kakaoLogInShow.toggle()
    }
    
    @MainActor
    func kakaoCodeFetchSuccess(authorizationCode: String) {
        self.loading = true
        Task {
            do {
                try await self.kakaoLogInUseCase.execute(authorizationCode: authorizationCode)
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.loading = false
                    logInCompleted()
                }
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.loading = false
                }
            }
        }
    }
    
    func kakaoLogInFailed() { }
    
    public func privacyInfoButtonTapped() {
        self.linkInfoItem = LinkInfoItem(
            title: "개인정보처리방침",
            url: URL(string: Constant.WebURLLinks.privacyPolicy)
        )
    }
    
    public func termsOfServiceButtonTapped() {
        self.linkInfoItem = LinkInfoItem(
            title: "서비스 이용약관",
            url: URL(string: Constant.WebURLLinks.termsOfService)
        )
    }
    
}
