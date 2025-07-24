//
//  Project.swift
//  Brake
//
//  Created by Derrick kim on 2025/07/11.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let isExample = true

let targets: [Target] = [
    .core(
        interface: .AppScreenTime,
        factory: .init(
            dependencies: [
                .shared,
                .core(interface: .LocalStorage)
            ]
        )
    ),
    .core(
        implements: .AppScreenTime,
        factory: .init(
            dependencies: [
                .core(interface: .AppScreenTime),
                .core(interface: .LocalStorage)
            ]
        )
    ),
    .core(
        testing: .AppScreenTime,
        factory: .init(
            dependencies: [
                .core(interface: .AppScreenTime)
            ]
        )
    ),
    .core(
        tests: .AppScreenTime,
        factory: .init(
            dependencies: [
                .core(testing: .AppScreenTime)
            ]
        )
    ),
    // Example App (uses actual extensions)
    .core(
        example: .AppScreenTime,
        deploymentTarget: .debug,
        factory: .init(
            bundleId: "\(Project.Environment.bundlePrefix).appscreentime.example",
            infoPlist: Project.Environment.testAppInfoPlist(),
            entitlements: "CoreAppScreenTimeExample.entitlements",
            dependencies: [
                .core(interface: .AppScreenTime),
                .core(implements: .AppScreenTime),
                .target(name: "CoreAppScreenTimeDeviceActivityMonitorExtension"),
                .target(name: "CoreAppScreenTimeShieldConfigurationExtension"),
                .target(name: "CoreAppScreenTimeShieldActionConfigurationExtension")
            ],
            settings: Project.Environment.debugTargetSettings
        )
    ),
    // Example용 App Extensions
    .core(
        deviceActivityMonitorExtension: .AppScreenTime,
        factory: .init(
            name: "CoreAppScreenTimeDeviceActivityMonitorExtension",
            bundleId: "\(Project.Environment.bundlePrefix).appscreentime.example.DeviceActivityMonitorExtension",
            infoPlist: Project.Environment.appScreenTimeDeviceActivityMonitorExtensionInfoPlist(),
            entitlements: "Extensions/DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.entitlements",
            dependencies: [
                .core(interface: .AppScreenTime),
                .core(implements: .AppScreenTime),
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage)
            ],
            settings: Project.Environment.projectSettings
        )
    ),
    .core(
        shieldConfigurationExtension: .AppScreenTime,
        factory: .init(
            name: "CoreAppScreenTimeShieldConfigurationExtension",
            bundleId: "\(Project.Environment.bundlePrefix).appscreentime.example.ShieldConfigurationExtension",
            infoPlist: Project.Environment.appScreenTimeShieldConfigurationExtensionInfoPlist(),
            entitlements: "Extensions/ShieldConfigurationExtension/ShieldConfigurationExtension.entitlements",
            dependencies: [
                .core(interface: .AppScreenTime),
                .core(implements: .AppScreenTime),
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage)
            ],
            settings: Project.Environment.projectSettings
        )
    ),
    .core(
        shieldActionConfigurationExtension: .AppScreenTime,
        factory: .init(
            name: "CoreAppScreenTimeShieldActionConfigurationExtension",
            bundleId: "\(Project.Environment.bundlePrefix).appscreentime.example.ShieldActionConfigurationExtension",
            infoPlist: Project.Environment.appScreenTimeShieldActionConfigurationExtensionInfoPlist(),
            entitlements: "Extensions/ShieldActionConfigurationExtension/ShieldActionConfigurationExtension.entitlements",
            dependencies: [
                .core(interface: .AppScreenTime),
                .core(implements: .AppScreenTime),
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage)
            ],
            settings: Project.Environment.projectSettings
        )
    )
]

let project: Project = .makeModule(
    name: ModulePath.Core.name + ModulePath.Core.AppScreenTime.rawValue,
    targets: targets,
    additionalFiles: [
        "./xcconfigs/Shared.xcconfig"
    ]
)
