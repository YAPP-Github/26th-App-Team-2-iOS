//
//  BlockTimeEntity.swift
//  DomainScreenTimeManagement
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation
import Core

public struct BlockTimeEntity {
    public let hour: Int
    public let minute: Int

    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }

    func toRequest() -> BlockTime {
        return BlockTime(
            hour: hour,
            minute: minute
        )
    }
}
