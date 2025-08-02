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
        public static let currentAppVersion: String = "1.0.0"
        
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
                "SWIFT_VERSION": "5.9",
                "CODE_SIGN_ALLOW_ENTITLEMENTS_MODIFICATION": "YES"
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
        
        public static let exampleTargetSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": "${DEVELOPMENT_TEAM_ID}",
                "CODE_SIGN_STYLE": "Automatic",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                "ENABLE_DEBUG_DYLIB": "YES",
                "SWIFT_VERSION": "5.9"
            ],
            configurations: [
                .build(.debug)
            ]
        )
        
        public static func appInfoPlist(deploymentTarget: ProjectDeploymentTarget) -> InfoPlist {
            let kakaoJSAppKey: String
            let kakaoRESTAPIKey: String
            let baseServerURL: String
            
            switch deploymentTarget {
            case .debug:
                kakaoJSAppKey = "${KAKAO_JS_KEY_DEBUG}"
                kakaoRESTAPIKey = "${KAKAO_REST_API_KEY_DEBUG}"
                baseServerURL = "${BASE_SERVER_URL_DEBUG}"
            case .release:
                kakaoJSAppKey = "${KAKAO_JS_KEY_RELEASE}"
                kakaoRESTAPIKey = "${KAKAO_REST_API_KEY_RELEASE}"
                baseServerURL = "${BASE_SERVER_URL_RELEASE}"
            }
            
            var plist: [String: Plist.Value] =  [
                "CFBundleShortVersionString": "\(currentAppVersion)",
                "CFBundleVersion": "1",
                "UILaunchStoryboardName": "LaunchScreen",
                "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
                "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
                "NSFamilyControlsUsageDescription": "스크린타임 데이터를 관리하기 위해 접근 권한이 필요합니다.",
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": true,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [[
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ]]
                    ]
                ],
                "KAKAO_REST_API_KEY": "\(kakaoRESTAPIKey)",
                "KAKAO_JS_KEY": "\(kakaoJSAppKey)",
                "KAKAO_REDIRECT_URL": "${KAKAO_REDIRECT_URL}",
                
                "LSApplicationQueriesSchemes": [
                    "kakaokompassauth",
                    "kakaolink"
                ],
                "BASE_SERVER_URL": "\(baseServerURL)",
                "ACCESS_TOKEN_KEY": "${ACCESS_TOKEN_KEY}",
                "REFRESH_TOKEN_KEY": "${REFRESH_TOKEN_KEY}",
                "DEVELOPMENT_TEAM_ID": "${DEVELOPMENT_TEAM_ID}",
                "APP_GROUP_NAME": "${APP_GROUP_NAME}",
                "ITSAppUsesNonExemptEncryption": false,
                "UIUserInterfaceStyle": "Dark"
            ]
            return .extendingDefault(with: plist)
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
                "NSFamilyControlsUsageDescription": "앱 사용 시간을 관리하기 위해 Family Controls 권한이 필요합니다.",
                "LSApplicationQueriesSchemes": [
                    "kakaokompassauth",
                    "kakaolink"
                ],
                
                "KAKAO_JS_KEY_DEBUG" : "${KAKAO_JS_KEY_DEBUG}",
                "KAKAO_REST_API_KEY_DEBUG" : "${KAKAO_REST_API_KEY_DEBUG}",
                "KAKAO_JS_KEY_RELEASE" : "${KAKAO_JS_KEY_RELEASE}",
                "KAKAO_REST_API_KEY_RELEASE" : "${KAKAO_REST_API_KEY_RELEASE}",
                "KAKAO_REDIRECT_URL": "${KAKAO_REDIRECT_URL}",
                
                "BASE_SERVER_URL_RELEASE" : "${BASE_SERVER_URL_RELEASE}",
                "BASE_SERVER_URL_DEBUG" : "${BASE_SERVER_URL_DEBUG}",
                "ACCESS_TOKEN_KEY": "${ACCESS_TOKEN_KEY}",
                "REFRESH_TOKEN_KEY": "${REFRESH_TOKEN_KEY}",
                "DEVELOPMENT_TEAM_ID": "${DEVELOPMENT_TEAM_ID}",
                "APP_GROUP_NAME": "${APP_GROUP_NAME}",
                "ITSAppUsesNonExemptEncryption": false,
                "UIUserInterfaceStyle": "Dark"
            ])
        }
        
        public static func appScreenTimeDeviceActivityMonitorExtensionInfoPlist() -> InfoPlist {
            return .extendingDefault(with: [
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.deviceactivity.monitor-extension",
                    "NSExtensionPrincipalClass": "CoreAppScreenTimeDeviceActivityMonitorExtension.DeviceActivityMonitorExtension"
                ],
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "APP_GROUP_NAME": "${APP_GROUP_NAME}"
            ])
        }
        
        public static func appScreenTimeShieldConfigurationExtensionInfoPlist() -> InfoPlist {
            return .extendingDefault(with: [
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.ManagedSettingsUI.shield-configuration-service",
                    "NSExtensionPrincipalClass": "CoreAppScreenTimeShieldConfigurationExtension.ShieldConfigurationExtension"
                ],
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "APP_GROUP_NAME": "${APP_GROUP_NAME}"
            ])
        }
        
        public static func appScreenTimeShieldActionConfigurationExtensionInfoPlist() -> InfoPlist {
            return .extendingDefault(with: [
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.ManagedSettings.shield-action-service",
                    "NSExtensionPrincipalClass": "CoreAppScreenTimeShieldActionConfigurationExtension.ShieldActionConfigurationExtension"
                ],
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "APP_GROUP_NAME": "${APP_GROUP_NAME}"
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
