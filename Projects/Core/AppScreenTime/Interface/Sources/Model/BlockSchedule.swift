//
//  BlockSchedule.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation
import FamilyControls
import SharedUtil

public struct BlockSchedule: Equatable, JSONCodable {
    public let id: String
    public let title: String
    public let blockList: FamilyActivitySelection
    public let startTime: BlockTime
    public let endTime: BlockTime

    public init(
        id: String,
        title: String,
        blockList: FamilyActivitySelection,
        startTime: BlockTime,
        endTime: BlockTime
    ) {
        self.id = id
        self.title = title
        self.blockList = blockList
        self.startTime = startTime
        self.endTime = endTime
    }
}
