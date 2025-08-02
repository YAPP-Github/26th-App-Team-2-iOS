//
//  BlockSchedule+Entity.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

extension BlockSchedule {
    /// Core의 BlockSchedule을 Domain의 BlockScheduleEntity로 변환
    func toEntity() -> BlockScheduleEntity {
        return BlockScheduleEntity(
            id: self.id,
            title: self.title,
            blockList: self.blockList,
            startTime: self.startTime.toEntity(),
            endTime: self.endTime.toEntity()
        )
    }
}
