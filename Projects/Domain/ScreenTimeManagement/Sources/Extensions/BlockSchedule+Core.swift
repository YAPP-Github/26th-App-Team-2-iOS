//
//  BlockSchedule+Core.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import DomainScreenTimeManagementInterface
import Core

extension BlockScheduleEntity {
    /// Domain의 BlockTimeEntity를 Core의 BlockTime으로 변환
    func toCore() -> BlockSchedule {
        return BlockSchedule(
            id: self.id,
            title: self.title,
            blockList: self.blockList,
            startTime: self.startTime.toCore(),
            endTime: self.endTime.toCore()
        )
    }
}
