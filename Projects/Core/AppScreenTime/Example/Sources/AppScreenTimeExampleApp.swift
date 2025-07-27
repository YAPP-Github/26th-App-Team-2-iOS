//
//  AppScreenTimeExampleApp.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/11/25.
//

import SwiftUI
import FamilyControls
import CoreAppScreenTime
import ManagedSettings

@main
struct AppScreenTimeExampleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(BlockingViewModel())
        }
    }
}
