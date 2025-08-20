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
        case .extensionPrompt(let name, let time, let count, let startDate, let endDate):
            return .extensionPrompt(tokenName: name, time: time, count: count,startDate: startDate,endDate: endDate)
        case .cooldownActive(let tokenName, let time, let groupName, let startDate, let endDate):
            return .cooldownActive(tokenName: tokenName, time: time, groupName: groupName, startDate: startDate, endDate: endDate)
        }
    }
} 
