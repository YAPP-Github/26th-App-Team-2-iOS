//
//  LogInViewModel.swift
//  FeatureOnboarding
//
//  Created by Greem on 7/22/25.
//

import Foundation
import Domain
import SharedUtil

@Observable
public final class LogInViewModel {
    var linkInfoItem: ExternalLink?
    var kakaoLogInShow: Bool = false
    var loading: Bool = false
    
    private let appleLogInUseCase: AppleLogInUseCase
    private let kakaoLogInUseCase: KakaoLogInUseCase
    private let localLogInUseCase: LocalLogInUseCase
    
    private let logInCompleted: () -> ()
    
    public init(
        appleLogInUseCase: AppleLogInUseCase,
        kakaoLogInUseCase: KakaoLogInUseCase,
        localLogInUseCase: LocalLogInUseCase,
        logInCompleted: @escaping () -> ()
    ) {
        self.appleLogInUseCase = appleLogInUseCase
        self.kakaoLogInUseCase = kakaoLogInUseCase
        self.localLogInUseCase = localLogInUseCase
        self.logInCompleted = logInCompleted
    }
    
    @MainActor func onboardingStartButtonTapped() {
        localLogInUseCase.execute()
        logInCompleted()
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
        self.linkInfoItem = .privacyPolicy
    }
    
    public func termsOfServiceButtonTapped() {
        self.linkInfoItem = .termsOfService
    }
    public func webCompletedButtonTapped() {
        self.linkInfoItem = nil
    }
}
