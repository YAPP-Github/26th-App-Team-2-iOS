//
//  ApplicationBlocker.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/18/25.
//

import Foundation
import ManagedSettings
import DeviceActivity
import CoreAppScreenTimeInterface

struct ApplicationBlocker {

    private let store = ManagedSettingsStore()
    private let model = BlockingViewModel.shared

    init() { }

    func block(completion: @escaping (Result<Void, Error>) -> Void) {
        let deviceActivityCenter = DeviceActivityCenter()

        let blockSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        store.shield.applicationCategories = .specific(model.newSelection.categoryTokens)
        store.shield.applications = model.newSelection.applicationTokens
        store.shield.webDomains = model.newSelection.webDomainTokens

        do {
            try deviceActivityCenter.startMonitoring(DeviceActivityName.daily, during: blockSchedule)
        } catch {
            completion(.failure(error))
            return
        }
        completion(.success(()))
    }

    func clearShield() {
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy<Application>.none
        store.shield.applications = []
        store.shield.webDomains = []
    }

}
