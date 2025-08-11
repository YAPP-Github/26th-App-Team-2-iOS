//
//  ShieldActionConfigurationExtension.swift
//  Brake
//
//  Created by Derrick kim on 7/15/25.
//

import ManagedSettings
import UserNotifications
import CoreAppScreenTime
import CoreAppScreenTimeInterface
import CoreLocalStorageInterface
import CoreLocalStorage

// TODO: 설정된 앱 그룹 이름 받아야함

public class ShieldActionConfigurationExtension: ShieldActionDelegate {
    private let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()
    private let cooldownStorage: CooldownStorageProtocol = CooldownStorage()
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
            primaryButtonPressedAction(completionHandler: completionHandler)
        case .secondaryButtonPressed:
            secondaryButtonPressedAction(completionHandler: completionHandler)
        default:
            completionHandler(.close)
        }
    }

    private func primaryButtonPressedAction(completionHandler: @escaping (ShieldActionResponse) -> Void) {
        let status = appScheduleStorage.getBlockingStatus()
        switch status {
        case .blocking:
            // 노티피케이션 요청
            scheduleNotification()
            // AppScheduleStorage를 통해 차단 상태 저장
            appScheduleStorage.saveBlockingStatus(.unlockedTemporarily)
            completionHandler(.defer)
        case .unlockedTemporarily:
            // 버튼 없음
            break
        case .extensionPrompt(_, _, let startDate, let endDate):
            if .now < startDate.addingTimeInterval(60) {
                // 그만하기
                completionHandler(.close)
            } else if endDate < .now {
                // 노티피케이션 요청
                scheduleNotification()
                // AppScheduleStorage를 통해 차단 상태 저장
                appScheduleStorage.saveBlockingStatus(.unlockedTemporarily)
                completionHandler(.defer)
            } else {
                scheduleNotification()
                completionHandler(.defer)
            }
        case .cooldownActive:
            // 남은 시간 확인 - 쿨다운 상태 유지
            // TODO: 남은 시간 확인하기 부분
            scheduleNotification()
            completionHandler(.defer)
        case .none:
            // 상태가 없으면 기본 차단 상태로 처리
            scheduleNotification()
            appScheduleStorage.saveBlockingStatus(.unlockedTemporarily)
            completionHandler(.defer)
        }
    }

    private func secondaryButtonPressedAction(completionHandler: @escaping (ShieldActionResponse) -> Void) {
        let status = appScheduleStorage.getBlockingStatus()

        switch status {
        case .blocking:
            completionHandler(.close)
        case .unlockedTemporarily:
            appScheduleStorage.saveBlockingStatus(.blocking(tokenName: ""))
            completionHandler(.defer)
        case .extensionPrompt(let time, let count, let startDate, let endDate):
            if .now < startDate.addingTimeInterval(60) {
                if count < 1 {
                    // 연장 횟수 증가
                    let newCount = count + 1
                    appScheduleStorage.saveExtensionCount(newCount)
                    // 15분 연장 시간 설정 및 저장
                    appScheduleStorage.saveExtensionTime(time)

                    // DeviceActivity로 15분 휴식 시간 설정
                    startExtensionBreakTime(minutes: time)

                    let newStartDate: Date = .now.addingTimeInterval(15 * 60)
                    let newEndDate: Date = newStartDate.addingTimeInterval(15 * 60)

                    // 연장 프롬프트 상태 업데이트
                    appScheduleStorage.saveBlockingStatus(.extensionPrompt(time: time, count: newCount, startDate: newStartDate, endDate: newEndDate))

                    // 차단창 닫기 (15분 동안 앱 사용 가능)
                    completionHandler(.defer)
                }
                else if endDate < .now {
                    completionHandler(.close)
                } else {
                    // 최대 연장 횟수 도달 (총 30분 사용 완료) - sessionEnded 상태로 변경
                    let cooldownMinutes = appScheduleStorage.getExtensionTime() // 저장된 연장 시간 사용
                    handleExtensionTimeExhausted(groupName: "앱 그룹", cooldownMinutes: cooldownMinutes)
                    completionHandler(.defer)
                }
            }
            else if endDate < .now {
                completionHandler(.close)
            } else {
                completionHandler(.close)
            }

        case .cooldownActive:
            // 나가기
            completionHandler(.close)
        default:
            completionHandler(.close)
        }
    }

    // MARK: - Extension Time Management

    /// 15분 연장 시간 시작
    private func startExtensionBreakTime(minutes: Int) {
        do {
            // BreakTimeManager를 통해 15분 휴식 시간 생성
            let breakTimeManager = BreakTimeManager()
            try breakTimeManager.createBreakTime(minutes: minutes)

            // 알림 트리거 설정
            appScheduleStorage.saveSelectNotificationTrigger(false)
        } catch {
            // 연장 시간 설정 실패
        }
    }

    /// 연장 시간이 모두 사용된 경우 호출
    private func handleExtensionTimeExhausted(groupName: String, cooldownMinutes: Int) {
        let startDate = Date.now
        let endDate = startDate.addingTimeInterval(TimeInterval(cooldownMinutes * 60))
        let status = BlockingStatus.cooldownActive(
            tokenName: groupName,
            time: cooldownMinutes,
            groupName: groupName,
            startDate: startDate,
            endDate: endDate
        )
        appScheduleStorage.saveBlockingStatus(status)

        // 쿨다운 시작
        cooldownStorage.saveCooldownGroup(groupName: groupName)
        cooldownStorage.startCooldown(minutes: cooldownMinutes)
    }
    
    // 차단 화면에서 보여지는 거라 에러 핸들링 할 수 없음
    private func scheduleNotification() {
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
        let request = UNNotificationRequest(identifier: "BrakeNotification", content: content, trigger: trigger)
        
        return request
    }
}
