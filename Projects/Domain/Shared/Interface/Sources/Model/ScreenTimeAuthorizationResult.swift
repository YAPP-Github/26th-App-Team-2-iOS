//
//  ScreenTimeAuthorizationResult.swift
//  DomainShared
//
//  Created by Greem on 7/28/25.
//

import Foundation

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
