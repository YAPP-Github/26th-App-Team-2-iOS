//
//  ContentView.swift
//  CoreAppScreenTime
//
//  Created by Derrick kim on 7/20/25.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationStack {
            List {
                Section {
                    AllCustomButtonView()
                } header: {
                    Text("Custom Components")
                }
            }
        }
        .navigationTitle("앱 컴포넌트 관리")
    }

}

#Preview {
    ZStack {
        Color
            .white
            .ignoresSafeArea(.all)
        ContentView()
            .padding(.horizontal, 16)
    }
    .ignoresSafeArea(.all)
}
