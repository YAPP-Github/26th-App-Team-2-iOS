//
//  Project+Environment.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 6/18/25.
//

import Foundation
import ProjectDescription

public extension Project {
    enum Environment {
        public static let appName = "Brake"
        public static let deploymentTarget = DeploymentTargets.iOS("17.2")
        public static let currentAppVersion: String = "0.0.0"

        /// 앱 번들, 추후 변경사항
        public static let bundlePrefix = "yapp.breake"
        public static let projectSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": "${DEVELOPMENT_TEAM_ID}",
                "CODE_SIGN_STYLE": "Automatic",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES"
            ],
            configurations: [
                .build(.dev),
                .build(.prod)
            ]
        )
        public static let devTargetSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": "${DEVELOPMENT_TEAM_ID}",
                "CODE_SIGN_STYLE": "Automatic",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES"
            ],
            configurations: [
                .build(.dev)
            ]
        )
        public static let prodTargetSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": "${DEVELOPMENT_TEAM_ID}",
                "CODE_SIGN_STYLE": "Automatic",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES"
            ],
            configurations: [
                .build(.prod)
            ]
        )
        public static func appInfoPlist(deploymentTarget: ProjectDeploymentTarget) -> InfoPlist {
            let kakaoNativeAppKey: String
            let baseServerURL: String

            switch deploymentTarget {
            case .dev:
                kakaoNativeAppKey = "${KAKAO_NATIVE_APP_KEY_DEV}"
                baseServerURL = "${BASE_SERVER_URL_DEV}"
            case .prod:
                kakaoNativeAppKey =  "${KAKAO_NATIVE_APP_KEY_PROD}"
                baseServerURL = "${BASE_SERVER_URL_PROD}"
            }

            return .extendingDefault(with: [
                "CFBundleShortVersionString": "\(currentAppVersion)",
                "CFBundleVersion": "1",
                "UILaunchStoryboardName": "LaunchScreen",
                "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
                "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": true,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [[
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ]]
                    ]
                ],
                "CFBundleURLTypes": [
                    [
                        "CFBundleURLName": "",
                        "CFBundleURLSchemes": ["kakao\(kakaoNativeAppKey)"]
                    ]
                ],
                "KAKAO_NATIVE_APP_KEY": "\(kakaoNativeAppKey)",
                "BASE_SERVER_URL": "\(baseServerURL)",
                "LSApplicationQueriesSchemes": [
                    "kakaokompassauth",
                    "kakaolink"
                ],
                "ACCESS_TOKEN_KEY": "${ACCESS_TOKEN_KEY}",
                "REFRESH_TOKEN_KEY": "${REFRESH_TOKEN_KEY}",
                "DEVELOPMENT_TEAM_ID": "${DEVELOPMENT_TEAM_ID}",
                "ITSAppUsesNonExemptEncryption": false
            ])
        }
    }
}
