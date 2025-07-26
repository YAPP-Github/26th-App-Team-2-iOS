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
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage),
                .shared(implements: .Util)
            ]
        )
    ),
    .core(
        implements: .AppScreenTime,
        factory: .init(
            dependencies: [
                .core(interface: .AppScreenTime),
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage)
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
                .core(testing: .AppScreenTime),
                .core(implements: .AppScreenTime)
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
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage),
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
            infoPlist: "Extensions/DeviceActivityMonitorExtension/Info.plist",
            entitlements: "Extensions/DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.entitlements",
            dependencies: [
                .core(interface: .AppScreenTime),
                .core(implements: .AppScreenTime),
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage),
                .shared(implements: .Util)
            ],
            settings: Project.Environment.projectSettings
        )
    ),
    .core(
        shieldConfigurationExtension: .AppScreenTime,
        factory: .init(
            name: "CoreAppScreenTimeShieldConfigurationExtension",
            bundleId: "\(Project.Environment.bundlePrefix).appscreentime.example.ShieldConfigurationExtension",
            infoPlist: "Extensions/ShieldConfigurationExtension/Info.plist",
            entitlements: "Extensions/ShieldConfigurationExtension/ShieldConfigurationExtension.entitlements",
            dependencies: [
                .core(interface: .AppScreenTime),
                .core(implements: .AppScreenTime),
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage),
                .shared(implements: .Util)
            ],
            settings: Project.Environment.projectSettings
        )
    ),
    .core(
        shieldActionConfigurationExtension: .AppScreenTime,
        factory: .init(
            name: "CoreAppScreenTimeShieldActionConfigurationExtension",
            bundleId: "\(Project.Environment.bundlePrefix).appscreentime.example.ShieldActionConfigurationExtension",
            infoPlist: "Extensions/ShieldActionConfigurationExtension/Info.plist",
            entitlements: "Extensions/ShieldActionConfigurationExtension/ShieldActionConfigurationExtension.entitlements",
            dependencies: [
                .core(interface: .AppScreenTime),
                .core(implements: .AppScreenTime),
                .core(interface: .LocalStorage),
                .core(implements: .LocalStorage),
                .shared(implements: .Util)
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
