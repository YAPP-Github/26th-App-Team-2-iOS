//
//  UserNotificationAuthViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import Foundation
import Domain

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
    public var notificationAuthDeniedPresent: Bool = false
    public var notoficationAuthFailedResult: NotificationAuthorizationResult?
    
    private let requestUserNotificationAuthUseCase: RequestUserNotificationAuthUseCase
    private let notificationApproved: () -> ()
    
    public init(
        requestUserNotificationAuthUseCase: RequestUserNotificationAuthUseCase,
        notificationApproved: @escaping () -> ()
    ) {
        self.requestUserNotificationAuthUseCase = requestUserNotificationAuthUseCase
        self.notificationApproved = notificationApproved
    }
    
    public func authorizationButtonTapped() {
        Task {
            let result = await requestUserNotificationAuthUseCase.execute()
            await MainActor.run { [weak self] in
                guard let self else { return }
                switch result {
                case .approved:
                    notificationApproved()
                case .denied:
                    self.notificationAuthDeniedPresent = true
                    self.notoficationAuthFailedResult = result
                case .userRestricted, .unknownError:
                    self.notoficationAuthFailedResult = result
                    self.notificationAuthFiledPresent = true
                }
            }
        }
    }
//    
    public func userDeniedCancelTapped() {
        self.notoficationAuthFailedResult = .userRestricted
        self.notificationAuthFiledPresent = true
    }
}

