//
//  ShieldActionConfigurationExtension.swift
//  ShieldActionConfigurationExtension
//
//  Created by Derrick kim on 7/15/25.
//

import ManagedSettings
import UserNotifications
import CoreAppScreenTime
import CoreAppScreenTimeInterface
import CoreLocalStorageInterface
import CoreLocalStorage

public class ShieldActionConfigurationExtension: ShieldActionDelegate {
    public override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        handleApplications(action: action, completionHandler: completionHandler)
    }

    public override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        handleApplications(action: action, completionHandler: completionHandler)
    }

    public override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        handleApplications(action: action, completionHandler: completionHandler)
    }

    private func handleApplications(action: ShieldAction, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            // 노티피케이션 요청
            scheduleNotification(with: "Notification")
            // AppGroupsStorage를 통해 차단 상태 저장
            AppGroupsStorage.shared.saveBlockingStatus(true)
            completionHandler(.defer)
        case .secondaryButtonPressed:
            // 차단 상태가 true라면 차단 해제
            if AppGroupsStorage.shared.getBlockingStatus() {
                AppGroupsStorage.shared.saveBlockingStatus(false)
                completionHandler(.defer)
            } else {
                completionHandler(.close)
            }
        @unknown default:
            fatalError()
        }
    }

    private func scheduleNotification(with title: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "여기를 눌러 앱 사용 시작하기" // Using the custom title here
                content.body = "알림을 누르면 앱을 사용할 수 있어요!"
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

                let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)

                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            } else {
                print("Permission denied. \(error?.localizedDescription ?? "")")
            }
        }
    }
} 
