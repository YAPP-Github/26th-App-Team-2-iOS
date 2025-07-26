//
//  ScreenTimeAuthViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Greem on 7/25/25.
//

import Foundation
import FamilyControls
public extension ScreenTimeAuthorizationResult {
    var alertTitle: String {
        switch self {
        case .denied: "스크린 타임 권한 요청을 거부했습니다."
        case .unknownError: "알 수 없는 오류가 발생했어요"
        case .unavailableDevice: "기기 미지원"
        case .networkError: "네트워크 에러"
        case .restricted: "스크린타임 권한이 제한되어 있습니다."
        case .authenticationMethodUnavailable: "유저 인증에 오류가 발생했습니다."
        case .approved, .userCancel: ""
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
        case .userCancel, .approved: ""
        }
    }
}


@Observable
public final class ScreenTimeAuthViewModel {
    private let center: AuthorizationCenter = AuthorizationCenter.shared
    
    public var screenTimeAuthFailedPresent: Bool = false
    public var screenTimeAuthFailedResult: ScreenTimeAuthorizationResult?
    public var cancelScreenTimeGrantPresented: Bool = false
    public var screenTimeApproved: Bool = false
    
    private let requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase
    
    public init(
        requestScreenTimeAuthUseCase: RequestScreenTimeAuthUseCase
    ) {
        self.requestScreenTimeAuthUseCase = requestScreenTimeAuthUseCase
    }
    
    public func authorizationButtonTapped() {
        Task {
            let result = await self.requestScreenTimeAuthUseCase.execute()
            await MainActor.run { [weak self] in
                guard let self else { return }
                switch result {
                case .denied, .restricted, .unavailableDevice, .unknownError, .networkError, .authenticationMethodUnavailable:
                    self.screenTimeAuthFailedResult = result
                    self.screenTimeAuthFailedPresent = true
                case .userCancel:
                    self.cancelScreenTimeGrantPresented = true
                case .approved:
                    self.screenTimeApproved = true
                }
            }
        }
    }
}


// MARK: -- Domain 레이어로 내려줘야 함...
public struct RequestScreenTimeAuthUseCase {
    private let center: AuthorizationCenter = AuthorizationCenter.shared
    
    public init() { }
    
    public func execute() async -> ScreenTimeAuthorizationResult {
        let status = center.authorizationStatus
        switch status {
        case .notDetermined:
            do {
                try await center.requestAuthorization(for: FamilyControlsMember.individual)
            } catch let error as FamilyControlsError {
                switch error {
                case .restricted, .invalidAccountType: return .restricted
                case .unavailable: return .unavailableDevice
                case .invalidArgument, .authorizationConflict: return .unknownError
                case .authorizationCanceled: return .userCancel
                case .networkError: return.networkError
                case .authenticationMethodUnavailable: return .authenticationMethodUnavailable
                @unknown default: return .unknownError
                }
            } catch {
                return .unknownError
            }
        case .denied: return .denied
        case .approved: return .approved
        @unknown default: return .unknownError
        }
        return .unknownError
    }
}

public enum ScreenTimeAuthorizationResult: Equatable {
    case denied
    case restricted
    case unavailableDevice // 디바이스 및 기기 미지원
    case userCancel
    case approved
    case unknownError
    case networkError
    case authenticationMethodUnavailable
  
}
