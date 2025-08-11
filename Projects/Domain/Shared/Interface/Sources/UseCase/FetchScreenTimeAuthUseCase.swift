//
//  FetchScreenTimeAuthUseCase.swift
//  DomainSharedInterface
//
//  Created by Greem on 8/12/25.
//

import Foundation
import FamilyControls

public struct FetchScreenTimeAuthUseCase {
    private let center: AuthorizationCenter = AuthorizationCenter.shared
    
    public init() { }
    
    public func execute() -> ScreenTimeAuthorizationResult {
        let status = center.authorizationStatus
        switch status {
        case .notDetermined: return .unknownError
        case .denied: return .denied
        case .approved: return .approved
        @unknown default: return .unknownError
        }
    }
}
