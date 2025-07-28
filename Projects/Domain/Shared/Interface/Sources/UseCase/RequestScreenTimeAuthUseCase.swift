//
//  RequestScreenTimeAuthUseCase.swift
//  DomainShared
//
//  Created by Greem on 7/28/25.
//

import Foundation
import FamilyControls

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
