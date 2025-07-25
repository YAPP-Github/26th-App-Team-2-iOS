//
//  UserNotificationAuthView.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import SwiftUI

public struct UserNotificationAuthView: View {
    @Environment(UserNotificationAuthViewModel.self) var userNotificationAuthViewModel
    public init() {
        
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Button {
                userNotificationAuthViewModel.authorizationButtonTapped()
            } label: {
                Text("알림 노티피케이션 권한").font(.title)
            }
        }.alert(
            userNotificationAuthViewModel.notificationAuthorizationResult?.alertTitle ?? "",
            isPresented: .init(get: {
                userNotificationAuthViewModel.notificationGrantPresented
            }, set: {
                userNotificationAuthViewModel.notificationGrantPresented = $0
            }),
            presenting: userNotificationAuthViewModel.notificationAuthorizationResult,
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
                case .unknownError, .userRestricted:
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
