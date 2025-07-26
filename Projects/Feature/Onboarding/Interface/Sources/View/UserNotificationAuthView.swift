//
//  UserNotificationAuthView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import SwiftUI

public struct UserNotificationAuthView: View {
    @Environment(UserNotificationAuthViewModel.self) var userNotificationAuthViewModel
    public init() { }
    
    public var body: some View {
        VStack(spacing: 20) {
            Button {
                userNotificationAuthViewModel.authorizationButtonTapped()
            } label: {
                Text("알림 노티피케이션 권한").font(.title)
            }
            VStack(spacing: 8) {
                Text("테스트 처리 뷰")
                Button("userRestricted") {
                    self.userNotificationAuthViewModel.notoficationAuthFailedResult = .userRestricted
                    self.userNotificationAuthViewModel.notificationAuthFiledPresent = true
                }
                Button("Denied") {
                    self.userNotificationAuthViewModel.notoficationAuthFailedResult = .denied
                    self.userNotificationAuthViewModel.notificationAuthFiledPresent = true
                }
                Button("unknown error") {
                    self.userNotificationAuthViewModel.notoficationAuthFailedResult = .unknownError
                    self.userNotificationAuthViewModel.notificationAuthFiledPresent = true
                }
            }
        }
        .navigationDestination(isPresented: .init(get: {
            self.userNotificationAuthViewModel.notificationApproved
        }, set: {
            self.userNotificationAuthViewModel.notificationApproved = $0
        }), destination: {
            OnboardingCompletedView()
        })
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
