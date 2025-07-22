//
//  BlockingApplicationModel.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/11/25.
//

import Foundation
import FamilyControls
import ManagedSettings

final class BlockingViewModel: ObservableObject {
    static let shared = BlockingViewModel()

    init() {}

    @Published  var newSelection: FamilyActivitySelection = .init()

    var selectedAppsTokens: Set<ApplicationToken> {
        newSelection.applicationTokens
    }
}
