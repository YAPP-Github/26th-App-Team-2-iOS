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

let targets: [Target] = [
    .app(
        implements: .IOS,
        factory: .init(
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
                .post(
                    script: """
                ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
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
            ], dependencies: [
                .feature,
                .external(name: "FirebaseAnalytics"),
                .external(name: "FirebaseCrashlytics")
            ],
            /// Firebase Objc 오류를 위한 settings 설정
            /// 참고 URL: https://sy-catbutler.tistory.com/60
            settings: .settings(base: [
                "OTHER_LDFLAGS":["-all_load -Objc"],
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                "GENERATE_DEBUG_SYMBOLS": "YES",
                "STRIP_DEBUG_SYMBOLS_DURING_COPY": "NO",
                "STRIP_LINKED_PRODUCT": "NO",
                "SYMBOLS_HIDDEN_BY_DEFAULT": "NO",
                "ENABLE_DEBUG_DYLIB": "NO" /// xcode 16이상의 crashlytics dysm 파일을 못 찾는 dylib에러 해결
                ])
            
        )
    ),
    .app(
        implements: .NotificationExtension,
        factory: .init(
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1",
                "CFBundleVersion": "1",
                "CFBundleName": "Brake"
            ]),
            dependencies: [
                .feature
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Brake",
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "DX6WKZY687",
            "CODE_SIGN_STYLE": "Automatic"
        ]
    ),
    targets: targets
)
