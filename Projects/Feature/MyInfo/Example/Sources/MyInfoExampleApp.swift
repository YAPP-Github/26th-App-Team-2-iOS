//
//  MyInfoExampleApp.swift
//  FeatureMyInfo
//
//  Created by Assistant on 8/2/25.
//

import SwiftUI
import FeatureMyInfoInterface
import SharedUtil
import Domain

@main
struct MyInfoExampleApp: App {

    init() { }

    var body: some Scene {
        WindowGroup {
            MyInfoSettingView(userName: "카피바라", appVersion: "1.0.0")
        }
    }
} 
