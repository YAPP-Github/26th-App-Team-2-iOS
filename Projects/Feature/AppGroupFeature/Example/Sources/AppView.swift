//
//  AppGroupFeatureView.swift
//  Brake
//
//  Created by Greem on 2025/07/27.
//

import SwiftUI
import Domain
import Core
import FeatureAppGroupFeatureInterface

@main
struct FeatureAppGroupFeatureApp: App {
    
    var body: some Scene {
        WindowGroup {
            AppGroupMainView()
                .environment(
                    AppGroupMainViewModel(
                        fetchAppGroupUseCase: FetchAppGroupUseCase(
                            appGroupService: AppGroupService(appGroupStorage: AppGroupStorage())
                        )
                    )
                )
        }
    }
    
}
