//
//  BreakeApp.swift
//  Brake
//
//  Created by Derrick kim on 2025/01/27.
//

import SwiftUI
import FamilyControls
import ManagedSettings

@main
struct BreakeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
    }
}

#Preview {
    ContentView()
}
