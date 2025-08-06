//
//  BlockingStatus+Entity.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 8/1/25.
//

import Foundation
import Core
import DomainScreenTimeManagementInterface

extension BlockingStatus {
    /// Core의 BlockingStatus를 Domain의 BlockingStatusEntity로 변환
    func toEntity() -> BlockingStatusEntity {
        switch self {
        case .blocking(let tokenName):
            return .blocking(tokenName: tokenName)
        case .unlockedTemporarily:
            return .unlockedTemporarily
        case .extensionPrompt(let time, let count, let startDate, let endDate):
            return .extensionPrompt(time: time, count: count, startDate: startDate, endDate: endDate)
        case .sessionEnded(let time, let groupName):
            return .sessionEnded(time: time, groupName: groupName)
        case .cooldownActive(let tokenName, let time, let groupName, let startDate, let endDate):
            return .cooldownActive(tokenName: tokenName, time: time, groupName: groupName, startDate: startDate, endDate: endDate)
        }
    }
} 
