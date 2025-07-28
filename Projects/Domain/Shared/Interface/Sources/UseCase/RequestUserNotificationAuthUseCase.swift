//
//  RequestUserNotificationAuthUseCase.swift
//  DomainShared
//
//  Created by Greem on 7/28/25.
//

import Foundation
import NotificationCenter

public struct RequestUserNotificationAuthUseCase {
    
    public init() { }
    
    public func execute() async -> NotificationAuthorizationResult {
        let notificationSettings: UNNotificationSettings = await UNUserNotificationCenter.current().notificationSettings()
        let status: UNAuthorizationStatus = notificationSettings.authorizationStatus
        switch status {
        case .notDetermined, .ephemeral, .provisional:
            do {
                let reqeustResult = try await UNUserNotificationCenter
                    .current()
                    .requestAuthorization(
                        options: [ .alert, .badge, .sound ]
                    )
                if reqeustResult { // 권한 요청 허용
                    return .approved
                } else { // 권한 요청 거부
                    return .userRestricted
                }
            } catch {
                return .unknownError
            }
        case .denied: return .denied
        case .authorized: return .approved
        @unknown default: return .unknownError
        }
    }
}
