//
//  BlockingViewModel.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/26/25.
//

import CoreAppScreenTime
import CoreAppScreenTimeInterface
import CoreLocalStorageInterface
import CoreLocalStorage

import Foundation
import FamilyControls
import ManagedSettings

@Observable
final class BlockingViewModel {
    init() {}

    var newSelection: FamilyActivitySelection = .init()
    var isPresented = false
    var isPresentedTimerSettingView = false

    let blockScheduleManager: BlockScheduleProtocol = BlockScheduleManager()
    let breakTimeManager: BreakTimeProtocol = BreakTimeManager()
    let appScheduleStorage: AppScheduleStorageProtocol = AppScheduleStorage()

    @MainActor
    func blockViewOnAppeared() {
        self.isPresentedTimerSettingView = self.appScheduleStorage.getSelectedNotification()
    }
}

