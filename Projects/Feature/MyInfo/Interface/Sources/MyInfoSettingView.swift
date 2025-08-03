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

    @Environment(MyInfoSettingViewModel.self) private var viewModel

    public init() { }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 상단 컨텐츠 영역
                // 선택된 탭에 따라 다른 색상의 배경
                ZStack {
                    switch viewModel.selectedTab {
                    case .report:
                        Color.brakeYellowDark
                            .ignoresSafeArea()
                    case .dashboard:
                        Color.insightBlue
                            .ignoresSafeArea()
                    case .myInfo:
                        VStack {
                            userProfileSection
                                .padding(.top, 87)
                            // 메뉴 아이템들
                            menuItemsSection
                            Spacer()
                        }
                        .ignoresSafeArea()
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    // 하단 탭바
                    VStack {
                        BrakeTabBarView(selectedTabBarItem: .init(get: {
                            viewModel.selectedTab
                        }, set: { item in
                            viewModel.selectedTab = item
                        }))
                        .padding(.bottom, 16)
                    }
                }
            }
            .onAppear {
                viewModel.onAppear()
            }
            .background(Color.grey900)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: .init(get: {
                viewModel.showEditProfile
            }, set: { isPresented in
                viewModel.showEditProfile = isPresented
            })) {
                EditProfileView(
                    nickname: .init(
                        get: {
                            viewModel.nickname
                        },
                        set: { nickname in
                            viewModel.nickname = nickname
                        })
                )
                .environment(viewModel)
            }
            .brakePopUp(
                isPresented: .init(get: {
                    viewModel.showWithdrawalAlert
                }, set: { isPresented in
                    viewModel.showWithdrawalAlert = isPresented
                }),
                title: "정말 탈퇴하시겠어요?",
                message: "탈퇴하면 모든 계정 정보와 이용 기록이 삭제되며, 복구할 수 없습니다.",
                icon: Image.iconConfettiThunder,
                alertType: .doubleButton,
                primaryButtonTitle: "탈퇴",
                secondaryButtonTitle: "취소",
                primaryBackgroundColor: .buttonYellow,
                primaryTextColor: .grey900,
                secondaryBackgroundColor: .grey800,
                secondaryTextColor: .grey00,
                primaryAction: {
                    viewModel.confirmWithdrawal()
                },
                secondaryAction: {
                    viewModel.cancelWithdrawal()
                }
            )
            .brakePopUp(
                isPresented: .init(get: {
                    viewModel.showLogoutAlert
                }, set: { isPresented in
                    viewModel.showLogoutAlert = isPresented
                }),
                title: "로그아웃 하시겠습니까?",
                alertType: .doubleButton,
                primaryButtonTitle: "로그아웃",
                secondaryButtonTitle: "취소",
                primaryBackgroundColor: .buttonYellow,
                primaryTextColor: .grey900,
                secondaryBackgroundColor: .grey800,
                secondaryTextColor: .grey00,
                primaryAction: {
                    viewModel.confirmLogout()
                },
                secondaryAction: {
                    viewModel.cancelLogout()
                }
            )
            .toast(message: viewModel.showToast ? viewModel.toastMessage : nil)
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

            Text(viewModel.nickname)
                .font(.pretendard(size: 22, type: .semiBold))
                .foregroundColor(.grey00)

            Spacer()

            Button("수정") {
                viewModel.showEditProfile = true
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
                feedbackSubject: viewModel.feedbackSubject
            )

            LegalSectionView(
                appVersion: viewModel.appVersion,
                legalSubject: viewModel.legalSubject
            )

            AccountSectionView(
                accountSubject: viewModel.accountSubject
            )
        }
        .padding(.horizontal, 20)
        .onReceive(viewModel.feedbackSubject) { action in
            viewModel.handleMenuTap(action: action)
        }
        .onReceive(viewModel.legalSubject) { action in
            viewModel.handleMenuTap(action: action)
        }
        .onReceive(viewModel.accountSubject) { action in
            viewModel.handleMenuTap(action: action)
        }
    }
}
