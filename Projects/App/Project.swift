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
    ),
    .app(
        implements: .NotificationExtension,
        deploymentTarget: .dev,
        factory: .init(
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1",
                "CFBundleVersion": "1",
                "CFBundleName": "\(Project.Environment.appName)"
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
                "CFBundleName": "Brake"
            ]),
            settings: Project.Environment.prodTargetSettings
        )
    )
]

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
)
