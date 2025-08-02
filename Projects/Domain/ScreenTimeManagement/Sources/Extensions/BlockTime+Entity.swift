//
//  BlockTime+Entity.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

extension BlockTime {
    /// Core의 BlockTime을 Domain의 BlockTimeEntity로 변환
    func toEntity() -> BlockTimeEntity {
        return BlockTimeEntity(hour: self.hour, minute: self.minute)
    }
} 
