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
]

let appTargets: [Target] = [
    .app(
        implements: .iOS,
        deploymentTarget: .debug,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .debug),
            entitlements: "\(Project.Environment.appName).entitlements",
            scripts: Project.Environment.appScripts,
            dependencies: [
                .target(name: "BrakeNotificationExtension-Debug"),
                .target(name: "BrakeDeviceActivityMonitorExtension-Debug"),
                .target(name: "BrakeShieldConfigurationExtension-Debug"),
                .target(name: "BrakeShieldActionConfigurationExtension-Debug"),
                .feature
            ],
            settings: Project.Environment.debugTargetSettings
        )
    ),
    .app(
        implements: .iOS,
        deploymentTarget: .release,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .release),
            entitlements: "\(Project.Environment.appName).entitlements",
            scripts: Project.Environment.appScripts,
            dependencies: [
                .target(name: "BrakeNotificationExtension-Release"),
                .target(name: "BrakeDeviceActivityMonitorExtension-Release"),
                .target(name: "BrakeShieldConfigurationExtension-Release"),
                .target(name: "BrakeShieldActionConfigurationExtension-Release"),
                .feature
            ],
            settings: Project.Environment.releaseTargetSettings
        )
    ),
    .app(
        implements: .NotificationExtension,
        deploymentTarget: .debug,
        factory: .init(
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1",
                "CFBundleVersion": "1",
                "CFBundleName": "\(Project.Environment.appName)NotificationExtension-Debug",
                "CFBundleDisplayName": "\(Project.Environment.appName)Notification",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService"
                ]
            ]),
            dependencies: [
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage)
            ],
            settings: Project.Environment.debugTargetSettings
        )
    ),
    .app(
        implements: .NotificationExtension,
        deploymentTarget: .release,
        factory: .init(
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "CFBundleName": "\(Project.Environment.appName)NotificationExtension-Release",
                "CFBundleDisplayName": "\(Project.Environment.appName)Notification",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService"
                ]
            ]),
            dependencies: [
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage)
            ],
            settings: Project.Environment.releaseTargetSettings
        )
    ),
    .app(
        implements: .ShieldConfigurationExtension,
        deploymentTarget: .debug,
        factory: .init(
            dependencies: [
                .domain,
            ],
            settings: Project.Environment.debugTargetSettings
        )
    ),
    .app(
        implements: .ShieldConfigurationExtension,
        deploymentTarget: .release,
        factory: .init(
            dependencies: [
                .domain,
            ],
            settings: Project.Environment.releaseTargetSettings
        )
    ),
    .app( 
        implements: .ShieldActionConfigurationExtension,
        deploymentTarget: .debug,
        factory: .init(
            dependencies: [
                .domain
            ],
            settings: Project.Environment.debugTargetSettings
        )
    ),
    .app( 
        implements: .ShieldActionConfigurationExtension,
        deploymentTarget: .release,
        factory: .init(
            dependencies: [
                .domain
            ],
            settings: Project.Environment.releaseTargetSettings
        )
    ),
    .app(
        implements: .DeviceActivityMonitorExtension,
        deploymentTarget: .debug,
        factory: .init(
            dependencies: [
                .domain
            ],
            settings: Project.Environment.debugTargetSettings
        )
    ),
    .app(
        implements: .DeviceActivityMonitorExtension,
        deploymentTarget: .release,
        factory: .init(
            dependencies: [
                .domain
            ],
            settings: Project.Environment.releaseTargetSettings
        )
    ),
    .app(
        tests: .iOS,
        factory: .init(
            infoPlist: Project.Environment.testAppInfoPlist(),
            entitlements: "\(Project.Environment.appName).entitlements",
            scripts: Project.Environment.appScripts,
            dependencies: [
                .feature
            ],
            settings: Project.Environment.debugTargetSettings
        )
    )
]

let project: Project = .makeModule(
    name: Project.Environment.appName,
    targets: appTargets,
    schemes: appSchemes,
    additionalFiles: [
        "./xcconfigs/Shared.xcconfig",
        "./xcconfigs/TokenKeys.xcconfig"
    ]
)

