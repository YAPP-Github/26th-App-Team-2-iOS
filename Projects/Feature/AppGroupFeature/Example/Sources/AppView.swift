//
//  AppGroupFeatureView.swift
//  Brake
//
//  Created by Greem on 2025/07/27.
//

import SwiftUI
import FeatureAppGroupFeatureInterface

@main
struct FeatureAppGroupFeatureApp: App {
    
    var body: some Scene {
        WindowGroup {
            AppGroupMainView()
                .environment(AppGroupMainViewModel())
        }
    }
    
}
