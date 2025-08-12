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
    
    public func execute() async -> ScreenTimeAuthorizationResult {
        /// 동기 로직 처리시 notDetermined로 바로 떨어지는 엣지케이스 대응
        try? await Task.sleep(for: .seconds(0.1))
        let status = center.authorizationStatus
        switch status {
        case .notDetermined: return .unknownError
        case .denied: return .denied
        case .approved: return .approved
        @unknown default: return .unknownError
        }
    }
}
