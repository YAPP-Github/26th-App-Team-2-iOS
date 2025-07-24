//
//  BlockSchedule.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation
import FamilyControls
import SharedUtil

public struct BlockSchedule: JSONCodable, Equatable {
    public let id: String
    public let title: String
    public let blockList: FamilyActivitySelection
    public let startTime: BlockTime
    public let endTime: BlockTime
}
