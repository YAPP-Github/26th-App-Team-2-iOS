//
//  BlockingStatusEntity+Core.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 8/1/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

extension BlockingStatusEntity {
    /// Domain의 BlockingStatusEntity를 Core의 BlockingStatus로 변환
    public func toCore() -> BlockingStatus {
        switch self {
        case .blocking(let tokenName):
            return .blocking(tokenName: tokenName)
        case .unlockedTemporarily:
            return .unlockedTemporarily
        case .extensionPrompt(let time, let count):
            return .extensionPrompt(time: time, count: count)
        case .sessionEnded(let time, let groupName):
            return .sessionEnded(time: time, groupName: groupName)
        case .cooldownActive(let tokenName, let time, let groupName):
            return .cooldownActive(tokenName: tokenName, time: time, groupName: groupName)
        }
    }
} 
