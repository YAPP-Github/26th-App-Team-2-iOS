//
//  ManagedSettingsStore.Name.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/26/25.
//

import Foundation
import FamilyControls
import ManagedSettings
import CoreAppScreenTimeInterface

// ManagedSettingsStore 의 ID 형식
extension ManagedSettingsStore.Name { 
    public init(id: String) {
        self = .init(id)
    }
}
