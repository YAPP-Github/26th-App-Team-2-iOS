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
    func startBlockSchedule(_ schedule: BlockSchedule)
    func endBlockSchedule(_ schedule: BlockSchedule)
    func readAll() -> [BlockSchedule]
    func read(_ id: String) -> BlockSchedule?
}
