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

                Section {
                    NavigationLink("TabBarView_ex") {
                        BrakeTabBarView_ex()
                    }

                    NavigationLink("BrakeNavigationView_ex") {
                        BrakeNavigationView_ex()
                    }

                    NavigationLink("BrakeTextFieldView_ex") {
                        BrakeTextFieldView_ex()
                    }
                    NavigationLink("BrakeToastView_ex") {
                        BrakeToastView_ex()
                    }
                    NavigationLink("BrakePopUpView_ex") {
                        BrakePopUpView_ex()
                    }
                    NavigationLink("Timer_ex") {
                        TimerView_ex()
                    }
                } header: {
                    Text("Custom Views")
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
