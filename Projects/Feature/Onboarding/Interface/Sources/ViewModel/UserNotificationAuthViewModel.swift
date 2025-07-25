//
//  UserNotificationAuthViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import Foundation
import NotificationCenter

@Observable
public final class UserNotificationAuthViewModel {
    
    public var notificationGrantPresented: Bool = false
    public var notificationAuthorizationResult: NotificationAuthorizationResult?
    
    public init() {
        
    }
    
    public func authorizationButtonTapped() {
        Task {
            let notificationSettings: UNNotificationSettings = await UNUserNotificationCenter.current().notificationSettings()
            let status: UNAuthorizationStatus = notificationSettings.authorizationStatus
            switch status {
            case .notDetermined, .ephemeral, .provisional:
                let reqeustResult = try await UNUserNotificationCenter
                    .current()
                    .requestAuthorization(
                        options: [ .alert, .badge, .sound ]
                    )
                print("요청 결과: \(reqeustResult)")
                if reqeustResult { // 권한 요청 허용
                    print("요청 허가에 따른 다른 처리하기")
                } else { // 권한 요청 거부
                    notificationAuthorizationResult = .userRestricted
                }
            case .denied:
                notificationAuthorizationResult = .denied
            case .authorized: break
            @unknown default:
                notificationAuthorizationResult = .unknownError
            }
        }
    }
}


public enum NotificationAuthorizationResult: Equatable {
    case denied
    case userRestricted
    case unknownError
    
    var alertTitle: String {
        switch self {
        case .denied, .userRestricted: "알림을 거부했습니다."
        case .unknownError: "알 수 없는 오류가 발생했어요"
        }
    }
    var alertDescription: String {
        switch self {
        case .denied: "설정에서 권한을 허용해주세요"
        case .userRestricted: "설정에서 권한을 허용해주세요"
        case .unknownError: "나중에 다시 시도 해주세요"
        }
    }
}
