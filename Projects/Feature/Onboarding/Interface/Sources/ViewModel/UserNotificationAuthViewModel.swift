//
//  UserNotificationAuthViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import Foundation
import NotificationCenter

extension NotificationAuthorizationResult {
    public var alertTitle: String {
        switch self {
        case .denied, .userRestricted: "알림을 거부했습니다."
        case .unknownError: "알 수 없는 오류가 발생했어요"
        case .approved: ""
        }
    }
    public var alertDescription: String {
        switch self {
        case .denied: "설정에서 권한을 허용해주세요"
        case .userRestricted: "설정에서 권한을 허용해주세요"
        case .unknownError: "나중에 다시 시도 해주세요"
        case .approved: ""
        }
    }
}

@Observable
public final class UserNotificationAuthViewModel {
    
    public var notificationAuthFiledPresent: Bool = false
    public var notoficationAuthFailedResult: NotificationAuthorizationResult?
    public var notificationApproved: Bool = false
    
    private let requestUserNotificationAuthUseCase: RequestUserNotificationAuthUseCase
    
    public init(
        requestUserNotificationAuthUseCase: RequestUserNotificationAuthUseCase
    ) {
        self.requestUserNotificationAuthUseCase = requestUserNotificationAuthUseCase
    }
    
    public func authorizationButtonTapped() {
        Task {
            let result = await requestUserNotificationAuthUseCase.execute()
            await MainActor.run { [weak self] in
                guard let self else { return }
                switch result {
                case .approved:
                    self.notificationApproved = true
                case .denied, .userRestricted, .unknownError:
                    self.notoficationAuthFailedResult = result
                    self.notificationAuthFiledPresent = true
                }
            }
        }
    }
}


public enum NotificationAuthorizationResult: Equatable {
    case approved
    case denied
    case userRestricted
    case unknownError
}


public struct RequestUserNotificationAuthUseCase {
    
    public init() {
        
    }
    
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
