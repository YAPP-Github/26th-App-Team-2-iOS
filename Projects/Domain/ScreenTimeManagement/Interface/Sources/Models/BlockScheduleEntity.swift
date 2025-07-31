//
//  BlockScheduleEntity.swift
//  DomainSharedInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import Core
import FamilyControls

public struct BlockScheduleEntity {

    public let id: String
    public let title: String
    public let blockList: FamilyActivitySelection
    public let startTime: BlockTimeEntity
    public let endTime: BlockTimeEntity

    public init(
        id: String,
        title: String,
        blockList: FamilyActivitySelection,
        startTime: BlockTimeEntity,
        endTime: BlockTimeEntity
    ) {
        self.id = id
        self.title = title
        self.blockList = blockList
        self.startTime = startTime
        self.endTime = endTime
    }

    public func toRequest() -> BlockSchedule {
        return BlockSchedule(
            id: id,
            title: title,
            blockList: blockList,
            startTime: startTime.toRequest(),
            endTime: endTime.toRequest()
        )
    }

}
