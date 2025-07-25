//
//  ScreenTimeAuthViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import Foundation
import FamilyControls

public enum ScreenTimeAuthorizationResult: Equatable {
    case denied
    case restricted
    case unavailableDevice // 디바이스 및 기기 미지원
    case unknownError
    case networkError
    case authenticationMethodUnavailable
    
    var alertTitle: String {
        switch self {
        case .denied: "스크린 타임 권한 요청을 거부했습니다."
        case .unknownError: "알 수 없는 오류가 발생했어요"
        case .unavailableDevice: "기기 미지원"
        case .networkError: "네트워크 에러"
        case .restricted: "스크린타임 권한이 제한되어 있습니다."
        case .authenticationMethodUnavailable: "유저 인증에 오류가 발생했습니다."
        }
    }
    
    var alertDescription: String {
        switch self {
        case .denied: "[설정 확인] 설정 > 스크린 타임에 \"Brake\" 권한을 허용해주세요."
        case .unknownError: "다시 시도 해주세요."
        case .unavailableDevice: "해당 기기는 지원하지 않습니다."
        case .networkError: "유저 iCloud 로그인 인증을 진행할 수 없습니다. 다시 시도해주세요."
        case .restricted: "[설정 확인] 설정 > 스크린타임에서 제한이 걸려있는지 확인하세요."
        case .authenticationMethodUnavailable: "다시 시도 해주세요."
        }
    }
}


@Observable
public final class ScreenTimeAuthViewModel {
    private let center: AuthorizationCenter = AuthorizationCenter.shared
    
    public var screenTimeGrantPresented: Bool = false
    public var screenTimeAuthorizationResult: ScreenTimeAuthorizationResult?
    public var cancelScreenTimeGrantPresented: Bool = false
    
    public init() {}
    
    public func authorizationButtonTapped() {
        let status = center.authorizationStatus
        Task {
            switch status {
            case .notDetermined:
                do {
                    try await center.requestAuthorization(for: FamilyControlsMember.individual)
                } catch let error as FamilyControlsError {
                    switch error {
                    case .restricted, .invalidAccountType:
                        self.screenTimeAuthorizationResult = .restricted
                        self.screenTimeGrantPresented = true
                    case .unavailable:
                        self.screenTimeAuthorizationResult = .unavailableDevice
                        self.screenTimeGrantPresented = true
                    case .invalidArgument, .authorizationConflict:
                        self.screenTimeAuthorizationResult = .unknownError
                        self.screenTimeGrantPresented = true
                    case .authorizationCanceled:
                        self.cancelScreenTimeGrantPresented = true
                    case .networkError:
                        self.screenTimeAuthorizationResult = .networkError
                        self.screenTimeGrantPresented = true
                    case .authenticationMethodUnavailable:
                        self.screenTimeAuthorizationResult = .authenticationMethodUnavailable
                        self.screenTimeGrantPresented = true
                    @unknown default:
                        self.screenTimeAuthorizationResult = .unknownError
                        self.screenTimeGrantPresented = true
                    }
                } catch {
                    self.screenTimeAuthorizationResult = .unknownError
                    self.screenTimeGrantPresented = true
                }
            case .denied:
                self.screenTimeAuthorizationResult = .denied
                self.screenTimeGrantPresented = true
            case .approved: break
            @unknown default:
                self.screenTimeAuthorizationResult = .unknownError
                self.screenTimeGrantPresented = true
            }
        }
    }
}
