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

    @Environment(MyInfoSettingViewModel.self) private var myInfoSettingViewModel
    @Binding private var isTabBarHidden: Bool

    public init(isTabBarHidden: Binding<Bool>) {
        self._isTabBarHidden = isTabBarHidden
    }

    public var body: some View {
        @Bindable var viewModel = myInfoSettingViewModel

        NavigationStack {
            VStack(spacing: 0) {
                // 상단 컨텐츠 영역
                VStack {
                    userProfileSection
                        .padding(.top, 87)
                    // 메뉴 아이템들
                    menuItemsSection
                    Spacer()
                }
                .ignoresSafeArea()
            }
            .onAppear {
                myInfoSettingViewModel.onAppear()
            }
            .background(Color.grey900)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: .init(get: {
                myInfoSettingViewModel.showEditProfile
            }, set: { isPresented in
                myInfoSettingViewModel.showEditProfile = isPresented
                isTabBarHidden = isPresented
            })) {
                EditProfileView(
                    nickname: .init(
                        get: { myInfoSettingViewModel.nickname },
                        set: { myInfoSettingViewModel.nickname = $0 }
                    )
                )
                .environment(myInfoSettingViewModel)
            }
            .brakePopUp(
                isPresented: .init(get: {
                    myInfoSettingViewModel.showWithdrawalAlert
                }, set: { isPresented in
                    myInfoSettingViewModel.showWithdrawalAlert = isPresented
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
                    myInfoSettingViewModel.confirmWithdrawal()
                },
                secondaryAction: {
                    myInfoSettingViewModel.cancelWithdrawal()
                }
            )
            .brakePopUp(
                isPresented: .init(get: {
                    myInfoSettingViewModel.showLogoutAlert
                }, set: { isPresented in
                    myInfoSettingViewModel.showLogoutAlert = isPresented
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
                    myInfoSettingViewModel.confirmLogout()
                },
                secondaryAction: {
                    myInfoSettingViewModel.cancelLogout()
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
            .toast(message: myInfoSettingViewModel.showToast ? myInfoSettingViewModel.toastMessage : nil)
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

            Text(myInfoSettingViewModel.nickname)
                .font(.pretendard(size: 22, type: .semiBold))
                .foregroundColor(.grey00)

            Spacer()

            Button("수정") {
                myInfoSettingViewModel.showEditProfile = true
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
                feedbackSubject: myInfoSettingViewModel.feedbackSubject
            )

            LegalSectionView(
                appVersion: myInfoSettingViewModel.appVersion,
                legalSubject: myInfoSettingViewModel.legalSubject
            )

            AccountSectionView(
                accountSubject: myInfoSettingViewModel.accountSubject
            )
        }
        .padding(.horizontal, 20)
        .onReceive(myInfoSettingViewModel.feedbackSubject) { action in
            myInfoSettingViewModel.handleMenuTap(action: action)
        }
        .onReceive(myInfoSettingViewModel.legalSubject) { action in
            myInfoSettingViewModel.handleMenuTap(action: action)
        }
        .onReceive(myInfoSettingViewModel.accountSubject) { action in
            myInfoSettingViewModel.handleMenuTap(action: action)
        }
    }
    
}
