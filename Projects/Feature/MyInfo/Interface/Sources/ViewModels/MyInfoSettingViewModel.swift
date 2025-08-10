//
//  MyInfoSettingViewModel.swift
//  FeatureMyInfo
//
//  Created by Derrick kim on 8/2/25.
//

import Foundation
import Combine
import SharedDesignSystem
import DomainUserInterface
import DomainOAuthInterface
import SharedUtil

@Observable
public final class MyInfoSettingViewModel {
    var linkInfoItem: ExternalLink?

    public var nickname: String = ""

    public var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    public var showWithdrawalAlert = false
    public var showLogoutAlert = false

    public var showEditProfile = false
    
    // MARK: - Toast States
    public var showToast = false
    public var toastMessage = ""
    
    public let feedbackSubject = PassthroughSubject<SettingAction, Never>()
    public let legalSubject = PassthroughSubject<SettingAction, Never>()
    public let accountSubject = PassthroughSubject<SettingAction, Never>()
    
    // MARK: - Initializer
    
    private let fetchUserNicknameUseCase: FetchUserNicknameUseCaseProtocol
    private let userSetNicknameUseCase: UserSetNicknameUseCase
    private let deleteUserUseCase: DeleteUserUseCaseProtocol
    private let oAuthLogoutUseCase: OAuthLogoutUseCaseProtocol
    private let onLogout: (() -> Void)?

    public init(
        fetchUserNicknameUseCase: FetchUserNicknameUseCaseProtocol,
        userSetNicknameUseCase: UserSetNicknameUseCase,
        deleteUserUseCase: DeleteUserUseCaseProtocol,
        oAuthLogoutUseCase: OAuthLogoutUseCaseProtocol,
        onLogout: (() -> Void)? = nil
    ) {
        self.fetchUserNicknameUseCase = fetchUserNicknameUseCase
        self.userSetNicknameUseCase = userSetNicknameUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.oAuthLogoutUseCase = oAuthLogoutUseCase
        self.onLogout = onLogout
    }
    
    // MARK: - Actions
    // TODO: 병합 시 웹뷰 열기 해야함
    public func handleMenuTap(action: SettingAction) {
        switch action {
        case .feedback:
            linkInfoItem = .feedback
        case .contact:
            linkInfoItem = .contactUs
        case .privacyPolicy:
            linkInfoItem = .privacyPolicy
        case .termsOfService:
            linkInfoItem = .termsOfService
        case .logout:
            showLogoutAlert = true
        case .withdraw:
            showWithdrawalAlert = true
        }
    }
    
    public func confirmWithdrawal() {
        showWithdrawalAlert = false
        deleteUser()
    }
    
    public func cancelWithdrawal() {
        showWithdrawalAlert = false
    }
    
    public func confirmLogout() {
        showLogoutAlert = false
        logout()
    }
    
    public func cancelLogout() {
        showLogoutAlert = false
    }
    
    public func onAppear() {
        fetchUserNickname()
    }
    
    public func editNickname(_ newNickname: String) async throws {
        try await userSetNicknameUseCase.execute(nickname: newNickname)
        // 성공 시 닉네임 업데이트
        await MainActor.run { [weak self] in
            guard let self else { return }
            self.nickname = newNickname
        }
    }

    public func webCompletedButtonTapped() {
        self.linkInfoItem = nil
    }

    private func logout() {
        Task { @MainActor in
            do {
                try await oAuthLogoutUseCase.execute()
                // 로그아웃 성공 시 콜백 호출
                onLogout?()
            } catch {
                toastMessage = "로그아웃에 실패했습니다."
                showToast = true

                try? await Task.sleep(for: .seconds(1.0))
                showToast = false
            }
        }
    }

    private func deleteUser() {
        Task { @MainActor in
            do {
                try await deleteUserUseCase.execute()
                // 탈퇴 성공 시 콜백 호출
                onLogout?()
            } catch {
                toastMessage = "회원탈퇴에 실패했습니다."
                showToast = true

                try? await Task.sleep(for: .seconds(1.0))
                showToast = false
            }
        }
    }

    private func fetchUserNickname() {
        Task { @MainActor in
            do {
                self.nickname = try await fetchUserNicknameUseCase.execute()
            } catch {
                toastMessage = "닉네임을 불러오는데 실패했습니다"
                showToast = true
                try? await Task.sleep(for: .seconds(1.0))
                showToast = false
            }
        }
    }

}
