//
//  BreakeApp.swift
//  ProjectDescriptionHelpers
//
//  Created by Greem on 6/22/25.
//

import SwiftUI
import Firebase
import FirebaseAnalytics
import FirebaseCrashlytics

@main
struct BreakeApp: App {
    
    init() {
        FirebaseApp.configure()
        print("Firebase API Key: \(FirebaseApp.app()?.options.apiKey ?? "N/A")")
    }
    
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
            
            Button {
                Analytics.logEvent("Xcode Cloud Analytics Log", parameters: nil)
            } label: {
                Text("Event on Analytics")
            }

            Button {
                fatalError("에러가 발생했습니다!!")
            } label: {
                Text("Event on Crashlytics")
            }

        }
    }
}

#Preview {
    ContentView()
}
