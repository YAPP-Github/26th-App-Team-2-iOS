//
//  Project.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 6/18/25.
//

import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

<<<<<<< HEAD
@MainActor let appTargetFactory: TargetFactory = .init(
    deploymentTargets: Project.Environment.deploymentTarget,
    infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "1",
        "CFBundleVersion": "1",
        "CFBundleName": "Brake",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": []
        ],
        "UILaunchScreen": .dictionary([
            "UILaunchScreen": .dictionary([:])
        ])
    ]),
    scripts: [
        .pre(
            path: .path("./scripts/set_firebase_api_key.sh"),
            name: "Google-Service Key Setting",
            basedOnDependencyAnalysis: false
        ),
        .post(
            path: .path("./scripts/run_crashlytics.sh"),
            name: "Firebase Crashlytics",
            inputPaths: [
        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
        "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)",
        "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)"
            ],
            basedOnDependencyAnalysis: false
        )   
    ],
    dependencies: [
        .feature,
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseCrashlytics")
    ],
    /// Firebase Objc 오류를 위한 settings 설정
    /// 참고 URL: https://sy-catbutler.tistory.com/60
    settings:
            .settings(base: [
                "OTHER_LDFLAGS":["-all_load -Objc"],
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                "GENERATE_DEBUG_SYMBOLS": "YES",
                "STRIP_DEBUG_SYMBOLS_DURING_COPY": "NO",
                "STRIP_LINKED_PRODUCT": "NO",
                "SYMBOLS_HIDDEN_BY_DEFAULT": "NO",
                "ENABLE_DEBUG_DYLIB": "NO", /// xcode 16이상의 crashlytics dysm 파일을 못 찾는 dylib 에러 해결
                "SWIFT_VERSION": "5.9"
            ]
            , defaultSettings: .none)
)

@MainActor let targets: [Target] = [
    
    .app(
        implements: .IOS,
        factory: appTargetFactory
=======
let appSchemes: [Scheme] = [
    .makeScheme(.dev, name: Project.Environment.appName),
    .makeScheme(.prod, name: Project.Environment.appName)
]

let appTargets: [Target] = [
    .app(
        implements: .iOS,
        deploymentTarget: .dev,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .dev),
            entitlements: "\(Project.Environment.appName).entitlements",
            dependencies: [
                .target(name: "Brake-DEV-NotificationExtension"),
                .feature
            ],
            settings: Project.Environment.devTargetSettings
        )
    ),
    .app(
        implements: .iOS,
        deploymentTarget: .prod,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .prod),
            entitlements: "\(Project.Environment.appName).entitlements",
            dependencies: [
                .target(name: "Brake-PROD-NotificationExtension"),
                .feature
            ],
            settings: Project.Environment.prodTargetSettings
        )
>>>>>>> develop
    ),
    .app(
        tests: .IOS,
        factory: appTargetFactory
    ),
    
    .app(
        implements: .NotificationExtension,
        deploymentTarget: .dev,
        factory: .init(
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1",
                "CFBundleVersion": "1",
                "CFBundleName": "\(Project.Environment.appName)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService"
                ]
            ]),
            settings: Project.Environment.devTargetSettings
        )
    ),
    .app(
        implements: .NotificationExtension,
        deploymentTarget: .prod,
        factory: .init(
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1",
                "CFBundleVersion": "1",
                "CFBundleName": "\(Project.Environment.appName)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService"
                ]
            ]),
            settings: Project.Environment.prodTargetSettings
        )
    )
]

<<<<<<< HEAD
@MainActor let project: Project = .makeModule(
    name: "Brake",
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "DX6WKZY687",
            "CODE_SIGN_STYLE": "Automatic"
        ]
    ),
    targets: targets
=======
let project: Project = .makeModule(
    name: Project.Environment.appName,
    targets: appTargets,
    schemes: appSchemes,
    additionalFiles: [
        "./xcconfigs/Shared.xcconfig",
        "./xcconfigs/KakaoSecretKeys.xcconfig",
        "./xcconfigs/TokenKeys.xcconfig",
        "./xcconfigs/Secrets.xcconfig"
    ]
>>>>>>> develop
)
