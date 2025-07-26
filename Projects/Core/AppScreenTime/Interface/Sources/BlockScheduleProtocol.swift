//
//  BlockScheduleProtocol.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/24/25.
//

import Foundation

public protocol BlockScheduleProtocol {
    func create(_ model: BlockSchedule) throws
    func delete(_ model: BlockSchedule)
    func update(_ model: BlockSchedule) throws
    func save(_ schedule: BlockSchedule) throws
}
