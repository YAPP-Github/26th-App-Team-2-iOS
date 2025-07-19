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
        public static let deploymentTarget = DeploymentTargets.iOS("17.2")
        public static let currentAppVersion: String = "0.0.0"
        
        /// 앱 이름, 타겟 이름 - 스키마 대응
        public static let appName = "Brake"
        public static func targetName(deploymentTarget: ProjectDeploymentTarget) -> String {
            switch deploymentTarget {
            case .debug: Project.Environment.appName + "-\(deploymentTarget.rawValue)"
            case .release: Project.Environment.appName
            }
        }
        
        /// 앱 번들 - 스키마 대응
        public static let bundlePrefix = "yapp.breake"
        public static func bundleId(deploymentTarget: ProjectDeploymentTarget) -> String {
            switch deploymentTarget {
            case .debug:  "\(Project.Environment.bundlePrefix).\(deploymentTarget.rawValue)"
            case .release: Project.Environment.bundlePrefix
            }
        }
        
        public static let projectSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": "${DEVELOPMENT_TEAM_ID}",
                "CODE_SIGN_STYLE": "Automatic",
                "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                "OTHER_LDFLAGS":["-all_load -Objc"],
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                "GENERATE_DEBUG_SYMBOLS": "YES",
                "STRIP_DEBUG_SYMBOLS_DURING_COPY": "NO",
                "STRIP_LINKED_PRODUCT": "NO",
                "SYMBOLS_HIDDEN_BY_DEFAULT": "NO",
                "ENABLE_DEBUG_DYLIB": "NO", /// xcode 16이상의 crashlytics dysm 파일을 못 찾는 dylib 에러 해결
                "SWIFT_VERSION": "5.9"
            ],
            configurations: [
                .build(.debug),
                .build(.release)
            ]
        )
        public static let debugTargetSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": "${DEVELOPMENT_TEAM_ID}",
                "CODE_SIGN_STYLE": "Automatic",
                "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
                "OTHER_LDFLAGS":["-all_load -Objc"],
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                "GENERATE_DEBUG_SYMBOLS": "YES",
                "STRIP_DEBUG_SYMBOLS_DURING_COPY": "NO",
                "STRIP_LINKED_PRODUCT": "NO",
                "SYMBOLS_HIDDEN_BY_DEFAULT": "NO",
                "ENABLE_DEBUG_DYLIB": "NO", /// xcode 16이상의 crashlytics dysm 파일을 못 찾는 dylib 에러 해결
                "SWIFT_VERSION": "5.9"
            ],
            configurations: [
                .build(.debug)
            ]
        )
        public static let releaseTargetSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": "${DEVELOPMENT_TEAM_ID}",
                "CODE_SIGN_STYLE": "Automatic",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                "OTHER_LDFLAGS":["-all_load -Objc"],
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                "GENERATE_DEBUG_SYMBOLS": "YES",
                "STRIP_DEBUG_SYMBOLS_DURING_COPY": "NO",
                "STRIP_LINKED_PRODUCT": "NO",
                "SYMBOLS_HIDDEN_BY_DEFAULT": "NO",
                "ENABLE_DEBUG_DYLIB": "NO", /// xcode 16이상의 crashlytics dysm 파일을 못 찾는 dylib 에러 해결
                "SWIFT_VERSION": "5.9"
            ],
            configurations: [
                .build(.release)
            ]
        )
        public static func appInfoPlist(deploymentTarget: ProjectDeploymentTarget) -> InfoPlist {
            let kakaoNativeAppKey: String
            let baseServerURL: String
            
            switch deploymentTarget {
            case .debug:
                kakaoNativeAppKey = "${KAKAO_NATIVE_APP_KEY_DEBUG}"
                baseServerURL = "${BASE_SERVER_URL_DEBUG}"
            case .release:
                kakaoNativeAppKey =  "${KAKAO_NATIVE_APP_KEY_RELEASE}"
                baseServerURL = "${BASE_SERVER_URL_RELEASE}"
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
        
        
        public static func testAppInfoPlist() -> InfoPlist {
            
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
                "LSApplicationQueriesSchemes": [
                    "kakaokompassauth",
                    "kakaolink"
                ],
                "KAKAO_NATIVE_APP_KEY_DEBUG": "${KAKAO_NATIVE_APP_KEY_DEBUG}",
                "KAKAO_NATIVE_APP_KEY_RELEASE" :  "${KAKAO_NATIVE_APP_KEY_RELEASE}",
                "BASE_SERVER_URL_DEBUG" : "${BASE_SERVER_URL_DEBUG}",
                "BASE_SERVER_URL_RELEASE" : "${BASE_SERVER_URL_RELEASE}",
                "ACCESS_TOKEN_KEY": "${ACCESS_TOKEN_KEY}",
                "REFRESH_TOKEN_KEY": "${REFRESH_TOKEN_KEY}",
                "DEVELOPMENT_TEAM_ID": "${DEVELOPMENT_TEAM_ID}",
                "ITSAppUsesNonExemptEncryption": false
            ])
        }
        
        public static let appScripts: [TargetScript] = [
            AppTargetScript.firebaseCrashlytics
        ]
    }
}


extension Project.Environment {
    enum AppTargetScript {
        
        static let firebaseCrashlytics: TargetScript = .post(
//            path: .path("./Scripts/run_crashlytics.sh"),
            script: """
ROOT_DIR=${TUIST_ROOT_DIR}
"${ROOT_DIR}/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/firebase-ios-sdk/Crashlytics/run"
echo "❗️ROOT_DIR Path: ${ROOT_DIR}"
""",
            name: "Firebase Crashlytics",
            inputPaths: [
                "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
                "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)",
                "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)"
            ],
            basedOnDependencyAnalysis: false
        )
    }
}
