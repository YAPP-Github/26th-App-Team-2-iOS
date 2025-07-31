//
//  ManagedSettingsStoreProtocol.swift
//  CoreAppScreenTimeInterface
//
//  Created by Derrick kim on 7/31/25.
//

import Foundation

public protocol ManagedSettingsStoreProtocol {
    func updateBlockList(for schedule: BlockSchedule)
    func clearBlockList(for schedule: BlockSchedule)
    func clearAllBlockLists(schedules: [BlockSchedule])
    func clearAllBlockListsForRest(schedules: [BlockSchedule])
}
