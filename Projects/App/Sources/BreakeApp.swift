//
//  BreakeApp.swift
//  Brake
//
//  Created by Derrick kim on 2025/01/27.
//

import SwiftUI
import Domain
import FeatureAppGroupFeatureInterface
import SharedDesignSystem

@main
struct BreakeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var selectedTab: TabItemType = .dashboard
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
