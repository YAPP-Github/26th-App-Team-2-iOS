//
//  BlockScheduleEntity.swift
//  DomainScreenTimeManagementInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation

public struct BlockScheduleEntity {
    public let id: String
    public let title: String
    public let blockList: Set<String>
    public let startTime: BlockTimeEntity
    public let endTime: BlockTimeEntity
    
    public init(
        id: String,
        title: String,
        blockList: Set<String>,
        startTime: BlockTimeEntity,
        endTime: BlockTimeEntity
    ) {
        self.id = id
        self.title = title
        self.blockList = blockList
        self.startTime = startTime
        self.endTime = endTime
    }
} 