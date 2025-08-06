//
//  ShieldActionConfigurationExtension.swift
//  Brake
//
//  Created by Derrick kim on 7/15/25.
//

import ManagedSettings
import UserNotifications
import DomainScreenTimeManagementInterface

public class ShieldActionConfigurationExtension: ShieldActionDelegate {
    private let extendBreakTimeUseCase: ExtendBreakTimeUseCaseProtocol
    private let handleExtensionTimeExhaustedUseCase: HandleExtensionTimeExhaustedUseCaseProtocol
    private let saveBlockingStatusUseCase: SaveBlockingStatusUseCaseProtocol
    private let openAppUseCase: OpenAppUseCaseProtocol
    private let getBlockingStatusUseCase: GetBlockingStatusUseCaseProtocol
    private let getExtensionTimeUseCase: GetExtensionTimeUseCaseProtocol

    override init() {
        let container = DIContainer()
        
        self.extendBreakTimeUseCase = container.makeExtendBreakTimeUseCase()
        self.handleExtensionTimeExhaustedUseCase = container.makeHandleExtensionTimeExhaustedUseCase()
        self.saveBlockingStatusUseCase = container.makeSaveBlockingStatusUseCase()
        self.openAppUseCase = container.makeOpenAppUseCase()
        self.getBlockingStatusUseCase = container.makeGetBlockingStatusUseCase()
        self.getExtensionTimeUseCase = container.makeGetExtensionTimeUseCase()

        super.init()
    }

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
        let status = getBlockingStatusUseCase.execute(tokenName: "")

        switch status {
        case .blocking:
            scheduleNotification()
            saveBlockingStatusUseCase.execute(.unlockedTemporarily)
            completionHandler(.defer)
        case .unlockedTemporarily:
            // 버튼 없음
            break
        case .extensionPrompt:
            // 그만하기
            completionHandler(.close)
        case .sessionEnded:
            // 남은 시간 확인 - 앱으로 이동
            openAppUseCase.execute()
            completionHandler(.close)
        case .cooldownActive:
            // 남은 시간 확인 - 앱으로 이동
            openAppUseCase.execute()
            completionHandler(.close)
        }
    }
    
    private func secondaryButtonPressedAction(completionHandler: @escaping (ShieldActionResponse) -> Void) {
        let status = getBlockingStatusUseCase.execute(tokenName: "")

        switch status {
        case .blocking:
            completionHandler(.close)
        case .unlockedTemporarily:
            // 다시 알림 보내기
            saveBlockingStatusUseCase.execute(.blocking(tokenName: ""))
            completionHandler(.defer)
        case .extensionPrompt(let time, let count, _, _):
            do {
                let extended = try extendBreakTimeUseCase.execute(time: time, count: count)
                if extended {
                    // 연장 성공 - 차단창 닫기
                    completionHandler(.defer)
                } else {
                    // 최대 연장 횟수 도달 - sessionEnded 상태로 변경
                    let cooldownMinutes = getExtensionTimeUseCase.execute()
                    handleExtensionTimeExhaustedUseCase.execute(groupName: "앱 그룹", cooldownMinutes: cooldownMinutes)
                    completionHandler(.defer)
                }
            } catch {
                // 에러 처리
            }
        case .sessionEnded:
            // 나가기
            completionHandler(.close)
        case .cooldownActive:
            // 나가기
            completionHandler(.close)
        }
    }

    // 차단 화면에서 보여지는 거라 에러 핸들링 할 수 없음
    // TODO: NOTIFICATION 처리 수정 필요
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
