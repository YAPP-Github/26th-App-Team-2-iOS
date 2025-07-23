//
//  Project.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 6/22/25.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .feature(
        interface: .Onboarding,
        factory: .init(
            dependencies: [
            .domain
        ])
    ),
    .feature(
        implements: .Onboarding,
        factory: .init(
            dependencies: [
                .feature(interface: .Onboarding)
            ]
        )
    ),
    .feature(
        testing: .Onboarding,
        factory: .init(
            dependencies: [
                .feature(interface: .Onboarding)
            ]
        )
    ),
    .feature(
        tests: .Onboarding,
        factory: .init(
            dependencies: [
                .feature(testing: .Onboarding)
            ]
        )
    ),
    .feature(
        example: .Onboarding,
        factory: .init(
            infoPlist: .onboardingExampleAppInfoPlist(
                deploymentTarget: .debug,
                bundleID: "\(Project.Environment.bundleId(deploymentTarget: .debug))-\(ModulePath.Feature.Onboarding.rawValue)"
            ),
            entitlements: "\(Project.Environment.appName).entitlements",
            dependencies: [
                .feature(interface: .Onboarding),
                .feature(implements: .Onboarding)
            ],
            settings: Project.Environment.exampleTargetSettings
        )
    )
]

let project: Project = .makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Onboarding.rawValue,
    targets: targets
)

fileprivate extension InfoPlist {
    static func onboardingExampleAppInfoPlist(deploymentTarget: ProjectDeploymentTarget, bundleID: String? = nil) -> InfoPlist {
        let kakaoNativeAppKey: String = "${KAKAO_NATIVE_APP_KEY_ONBOARDING_TEST}"
        let baseServerURL: String = "${BASE_SERVER_URL_DEBUG}"
        
        var plist: [String: Plist.Value] =  [
            "CFBundleShortVersionString": "\(Project.Environment.currentAppVersion)",
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
            "ITSAppUsesNonExemptEncryption": false,
        ]
        if let bundleID {
            plist["CFBundleIdentifier"] = Plist.Value(stringLiteral: bundleID)
        }
        
        return .extendingDefault(with: plist)
    }
}

