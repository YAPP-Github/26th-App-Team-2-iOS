//
//  BlockTimeEntity+Core.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

extension BlockTimeEntity {
    /// Domain의 BlockTimeEntity를 Core의 BlockTime으로 변환
    func toCore() -> BlockTime {
        return BlockTime(hour: self.hour, minute: self.minute)
    }
} 
