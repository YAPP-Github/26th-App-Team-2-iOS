//
//  BreakeApp.swift
//  ProjectDescriptionHelpers
//
//  Created by Greem on 6/22/25.
//

import SwiftUI

@main
struct BreakeApp: App {
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
            Text("Hello, Breake!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
