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

@Observable
public final class MyInfoSettingViewModel {
    
    public var nickname: String = ""

    public var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    public var showWithdrawalAlert = false
    public var showLogoutAlert = false
    
    public var selectedTab: TabItemType = .report
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

    public init(
        fetchUserNicknameUseCase: FetchUserNicknameUseCaseProtocol,
        userSetNicknameUseCase: UserSetNicknameUseCase,
        deleteUserUseCase: DeleteUserUseCaseProtocol,
        oAuthLogoutUseCase: OAuthLogoutUseCaseProtocol
    ) {
        self.fetchUserNicknameUseCase = fetchUserNicknameUseCase
        self.userSetNicknameUseCase = userSetNicknameUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.oAuthLogoutUseCase = oAuthLogoutUseCase
    }
    
    // MARK: - Actions
    // TODO: 병합 시 웹뷰 열기 해야함
    public func handleMenuTap(action: SettingAction) {
        switch action {
        case .feedback:
            break
        case .contact:
            break
        case .privacyPolicy:
            break
        case .termsOfService:
            break
        case .logout:
            showLogoutAlert = true
        case .withdraw:
            showWithdrawalAlert = true
        case .none:
            break
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
        self.nickname = newNickname
    }

    private func logout() {
        Task { @MainActor in
            do {
                try await oAuthLogoutUseCase.execute()
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
