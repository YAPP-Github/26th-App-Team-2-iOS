//
//  FetchUserNotificationAuthUseCase.swift
//  DomainSharedInterface
//
//  Created by Greem on 8/12/25.
//

import Foundation
import NotificationCenter

public struct FetchUserNotificationAuthUseCase {
    
    public init() { }
    
    public func execute() async -> NotificationAuthorizationResult {
        let notificationSettings: UNNotificationSettings = await UNUserNotificationCenter.current().notificationSettings()
        let status: UNAuthorizationStatus = notificationSettings.authorizationStatus
        switch status {
        case .notDetermined, .ephemeral, .provisional: return .denied
        case .denied: return .denied
        case .authorized: return .approved
        @unknown default: return .unknownError
        }
    }
}
