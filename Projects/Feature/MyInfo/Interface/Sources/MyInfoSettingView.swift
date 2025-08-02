//
//  MyInfoSettingView.swift
//  FeatureMyInfoInterface
//
//  Created by Derrick kim on 8/2/25.
//

import SwiftUI
import Combine
import SharedDesignSystem

public struct MyInfoSettingView: View {

    @State private var userName: String
    @State private var appVersion: String

    private let feedbackSubject = PassthroughSubject<SettingAction, Never>()
    private let legalSubject = PassthroughSubject<SettingAction, Never>()
    private let accountSubject = PassthroughSubject<SettingAction, Never>()

    public init(userName: String, appVersion: String) {
        self.userName = userName
        self.appVersion = appVersion
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 사용자 프로필 섹션
                userProfileSection

                // 메뉴 아이템들
                menuItemsSection

                Spacer()
            }
            .background(Color.grey900)
            .navigationBarHidden(true)
        }
    }

    // MARK: - 사용자 프로필 섹션
    private var userProfileSection: some View {
        HStack {
            // 프로필 이미지
            ZStack {
                Circle()
                    .fill(Color.grey850)
                    .frame(width: 60, height: 60)

                Image.iconProfile
                    .frame(width: 50, height: 47)
                    .offset(y: 9)
            }
            .mask(Circle())

            Text(userName)
                .font(.pretendard(size: 22, type: .semiBold))
                .foregroundColor(.grey00)

            Spacer()

            Button("수정") {

            }
            .font(.pretendard(size: 14, type: .semiBold))
            .foregroundColor(.grey500)
            .padding(.trailing, 16)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: - 메뉴 아이템 섹션
    private var menuItemsSection: some View {
        VStack(spacing: 16) {
            FeedbackSectionView(
                feedbackSubject: feedbackSubject
            )

            LegalSectionView(
                appVersion: appVersion,
                legalSubject: legalSubject
            )

            AccountSectionView(
                accountSubject: accountSubject
            )
        }
        .padding(.horizontal, 20)
        .onReceive(feedbackSubject) { action in
            handleMenuTap(action: action)
        }
        .onReceive(legalSubject) { action in
            handleMenuTap(action: action)
        }
        .onReceive(accountSubject) { action in
            handleMenuTap(action: action)
        }
    }

    // MARK: - 메뉴 탭 핸들러
    private func handleMenuTap(action: SettingAction) {
        switch action {
        case .feedback:
            // 의견 남기기 액션
            break
        case .contact:
            // 문의하기 액션
            break
        case .privacyPolicy:
            // 개인정보 처리방침 액션
            break
        case .termsOfService:
            // 서비스 약관 액션
            break
        case .logout:
            // 로그아웃 액션
            break
        case .withdraw:
            // 회원탈퇴 액션
            break
        case .none:
            // 액션 없음
            break
        }
    }
}

#Preview {
    MyInfoSettingView(userName: "카피바라", appVersion: "1.0.0")
        .preferredColorScheme(.dark)
}
