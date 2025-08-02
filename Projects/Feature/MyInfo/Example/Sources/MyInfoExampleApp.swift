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

    @Environment(\.diContainer) var diContainer

    init() { }

    var body: some Scene {
        WindowGroup {
            MyInfoSettingView()
                .environment(
                    MyInfoSettingViewModel(
                        fetchUserNicknameUseCase: diContainer.fetchUserNicknameUseCase,
                        userSetNicknameUseCase: diContainer.userSetNicknameUseCase,
                        deleteUserUseCase: diContainer.deleteUserUseCase,
                        oAuthLogoutUseCase: diContainer.oAuthLogoutUseCase
                    )
                )
        }
    }
} 
