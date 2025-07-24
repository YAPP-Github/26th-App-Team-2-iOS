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
                .target(name: "Brake-Debug-NotificationExtension"),
                .target(name: "BrakeDeviceActivityMonitorExtension"),
                .target(name: "BrakeShieldConfigurationExtension"),
                .target(name: "BrakeShieldActionConfigurationExtension"),
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
                .target(name: "Brake-Release-NotificationExtension"),
                .target(name: "BrakeDeviceActivityMonitorExtension"),
                .target(name: "BrakeShieldConfigurationExtension"),
                .target(name: "BrakeShieldActionConfigurationExtension"),
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
                "CFBundleName": "\(Project.Environment.appName)-\(ProjectDeploymentTarget.debug.rawValue)",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                    "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService"
                ]
            ]),
            settings: Project.Environment.debugTargetSettings
        )
    ),
    .app(
        implements: .NotificationExtension,
        deploymentTarget: .release,
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
            dependencies: [
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage)
            ],
            settings: Project.Environment.releaseTargetSettings
        )
    ),
    .app(
        implements: .ShieldConfigurationExtension,
        factory: .init(
            name: "BrakeShieldConfigurationExtension",
            infoPlist: "Extensions/ShieldConfigurationExtension/Info.plist",
            entitlements: "Extensions/ShieldConfigurationExtension/BrakeShieldConfigurationExtension.entitlements",
            dependencies: [
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage)
            ],
            settings: Project.Environment.projectSettings
        )
    ),
    .app( 
        implements: .ShieldActionConfigurationExtension,
        factory: .init(
            name: "BrakeShieldActionConfigurationExtension",
            infoPlist: "Extensions/ShieldActionConfigurationExtension/Info.plist",
            entitlements: "Extensions/ShieldActionConfigurationExtension/BrakeShieldActionConfigurationExtension.entitlements",
            dependencies: [
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage)
            ],
            settings: Project.Environment.projectSettings
        )
    ),
    .app(
        implements: .DeviceActivityMonitorExtension,
        factory: .init(
            name: "BrakeDeviceActivityMonitorExtension",
            infoPlist: "Extensions/DeviceActivityMonitorExtension/Info.plist",
            entitlements: "Extensions/DeviceActivityMonitorExtension/BrakeDeviceActivityMonitorExtension.entitlements",
            dependencies: [
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage)
            ],
            settings: Project.Environment.projectSettings
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
