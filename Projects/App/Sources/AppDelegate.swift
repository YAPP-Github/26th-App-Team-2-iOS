//
//  AppDelegate.swift
//  Brake
//
//  Created by Derrick kim on 2025/01/27.
//

import UIKit
import UserNotifications
import Core

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    private let appScheduleStorage = AppScheduleStorage()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        appScheduleStorage.saveSelectNotificationTrigger(false)
        return true
    }
    
    // 앱이 포그라운드에 있을 때 Notification을 받았을 때
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // Notification을 탭했을 때 (앱이 백그라운드/종료 상태에서)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Notification ID에 따른 처리
        switch response.notification.request.identifier {
        case "BrakeNotification":
            handleAppUnblockNotification()
        default:
            break
        }
        
        completionHandler()
    }

    private func handleAppUnblockNotification() {
        appScheduleStorage.saveSelectNotificationTrigger(true)
    }

}
