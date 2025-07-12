//
//  NotificationService.swift
//  Brake
//
//  Created by Derrick kim on 7/9/25.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        // 알림 처리 로직
        contentHandler(request.content)
    }
}
