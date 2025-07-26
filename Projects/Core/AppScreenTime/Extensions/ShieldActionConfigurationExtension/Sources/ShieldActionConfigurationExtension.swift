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
    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
    private let managedSettingsManager = ManagedSettingsStoreManager()

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
            // AppScheduleStorage를 통해 차단 상태 저장
            appScheduleStorage.saveBlockingStatus(true)
            completionHandler(.defer)
        case .secondaryButtonPressed:
            // 차단 상태가 true라면 차단 해제
            if appScheduleStorage.getBlockingStatus() {
                appScheduleStorage.saveBlockingStatus(false)
                
                // 모든 Shield 설정을 강제로 해제
                managedSettingsManager.clearAllBlockListsForRest(schedules: [])
                
                // 추가적인 강제 해제 시도
                DispatchQueue.main.async {
                    self.managedSettingsManager.clearAllBlockListsForRest(schedules: [])
                }
                
                // 지연 후 한 번 더 시도
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.managedSettingsManager.clearAllBlockListsForRest(schedules: [])
                }
                
                completionHandler(.defer)
            } else {
                completionHandler(.close)
            }
        @unknown default:
            fatalError()
        }
    }

    // 차단 화면에서 보여지는 거라 에러 핸들링 할 수 없음
    private func scheduleNotification(with title: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                center.add(self.makeNotification()) 
            } else {
                // Permission denied.
            }
        }
    }

    private func makeNotification() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "여기를 눌러 앱 사용 시작하기"
        content.body = "알림을 누르면 앱을 사용할 수 있어요!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)

        return request
    }
}
