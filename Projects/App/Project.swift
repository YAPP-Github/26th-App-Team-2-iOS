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

let appSchemes: [Scheme] = [
    .makeScheme(.debug, name: Project.Environment.appName),
    .makeScheme(.release, name: Project.Environment.appName)
//    .makeScheme(.dev, name: Project.Environment.appName),
//    .makeScheme(.prod, name: Project.Environment.appName)
]

let appTargets: [Target] = [
    .app(
        implements: .iOS,
        deploymentTarget: .dev,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .dev),
            entitlements: "\(Project.Environment.appName).entitlements",
            scripts: Project.Environment.appScripts,
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
            scripts: Project.Environment.appScripts,
            dependencies: [
                .target(name: "Brake-DEV-NotificationExtension"),
                .feature
            ],
            settings: Project.Environment.prodTargetSettings
        )
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
    ),
    
    .app(
        tests: .iOS,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .dev),
            entitlements: "\(Project.Environment.appName).entitlements",
            scripts: Project.Environment.appScripts,
            dependencies: [
                .feature
            ],
            settings: Project.Environment.devTargetSettings
        )
    ),
]

let project: Project = .makeModule(
    name: Project.Environment.appName,
    targets: appTargets,
    schemes: appSchemes,
    additionalFiles: [
        "./xcconfigs/Shared.xcconfig",
        "./xcconfigs/TokenKeys.xcconfig",
        "./xcconfigs/Secrets.xcconfig"
    ]
)
