//
//  UserNotificationAuthView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import SwiftUI
import SharedDesignSystem
import Domain

public struct UserNotificationAuthView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(StartUpViewModel.self) var startUpViewModel
    @Environment(UserNotificationAuthViewModel.self) var userNotificationAuthViewModel
    public init() { }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.grey900.ignoresSafeArea()
            VStack(spacing: 0) {
                BrakeNavigationView(title: {
                    EmptyView()
                }, leading: {
                    BrakeNavigationButton(type: .back) {
                        dismiss()
                    }
                })
                
                VStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("알림 타임 권한을").frame(height: 33)
                        Text("허용해주세요.").frame(height: 33)
                    }
                    .foregroundStyle(.white)
                    .font(.pretendard(size: 22, type: .semiBold))
                    Text("정확한 타이머 알림을 받아보세요.")
                        .foregroundStyle(Color.grey200)
                        .font(.pretendard(size: 16, type: .medium))
                }
                .padding(.top, 47)
                Spacer()
            }
            
            GeometryReader { proxy in
                ZStack {
                    Color.clear
                    Image.onboarding.notification
                        .resizable()
                        .frame(width: proxy.size.width * 0.8373)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            
            LargeButtonView(
                buttonType: .confirm,
                title: "허용하기",
                isActive: true
            ) {
                userNotificationAuthViewModel.authorizationButtonTapped()
            }
            .padding(.bottom, 16)
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert(
            userNotificationAuthViewModel.notoficationAuthFailedResult?.alertTitle ?? "",
            isPresented: .init(get: {
                userNotificationAuthViewModel.notificationAuthFiledPresent
            }, set: {
                userNotificationAuthViewModel.notificationAuthFiledPresent = $0
            }),
            presenting: userNotificationAuthViewModel.notoficationAuthFailedResult,
            actions: { result in
                switch result {
                case .denied:
                    Button("설정으로 이동") {
                        if let url = URL(string: UIApplication.openSettingsURLString),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    Button("취소", role: .cancel) {
                    }
                case .unknownError, .userRestricted, .approved:
                    Button("확인", role: .cancel) {
                    }
                }
            },
            message: { result in
                Text(result.alertDescription)
            }
        )
    }
}
