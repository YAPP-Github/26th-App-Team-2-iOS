//
//  Project.swift
//  Brake
//
//  Created by Greem on 2025/07/27.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name+ModulePath.Feature.AppGroupFeature.rawValue,
    targets: [
        .feature(
            interface: .AppGroupFeature,
            factory: .init(
                dependencies: [
                    .domain
                ]
            )
        ),
        .feature(
            implements: .AppGroupFeature,
            factory: .init(
                dependencies: [
                    .feature(interface: .AppGroupFeature)
                ]
            )
        ),
        .feature(
            testing: .AppGroupFeature,
            factory: .init(
                dependencies: [
                    .feature(interface: .AppGroupFeature),
                    .feature(implements: .AppGroupFeature)
                ]
            )
        ),
        .feature(
            tests: .AppGroupFeature,
            factory: .init(
                dependencies: [
                    .feature(testing: .AppGroupFeature),
                    .feature(interface: .AppGroupFeature)
                ]
            )
        ),
        .feature(
            example: .AppGroupFeature,
            factory: .init(
                infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .debug),
                entitlements: "\(Project.Environment.appName).entitlements",
                dependencies: [
                    .feature(interface: .AppGroupFeature),
                    .target(name: "FeatureAppGroupFeatureDeviceActivityMonitorExtension"),
                    .target(name: "FeatureAppGroupFeatureShieldConfigurationExtension"),
                    .target(name: "FeatureAppGroupFeatureShieldActionConfigurationExtension")
                    
                ],
                settings: Project.Environment.debugTargetSettings
            )
            
        ),
        .feature(
            deviceActivityMonitorExtension: .AppGroupFeature,
            factory: .init(
                name: "FeatureAppGroupFeatureDeviceActivityMonitorExtension",
                infoPlist: "Extensions/DeviceActivityMonitorExtension/Info.plist",
                entitlements: "Extensions/DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.entitlements",
                dependencies: [
                    .domain,
                    .feature(interface: .AppGroupFeature),
                    .feature(implements: .AppGroupFeature)
                ],
                settings: Project.Environment.projectSettings
            )
        ),
        .feature(
            shieldConfigurationExtension: .AppGroupFeature,
            factory: .init(
                name: "FeatureAppGroupFeatureShieldConfigurationExtension",
                infoPlist: "Extensions/ShieldConfigurationExtension/Info.plist",
                entitlements: "Extensions/ShieldConfigurationExtension/ShieldConfigurationExtension.entitlements",
                dependencies: [
                    .domain,
                    .feature(interface: .AppGroupFeature),
                    .feature(implements: .AppGroupFeature)
                ],
                settings: Project.Environment.projectSettings
            )
        ),
        .feature(
            shieldActionConfigurationExtension: .AppGroupFeature,
            factory: .init(
                name: "FeatureAppGroupFeatureShieldActionConfigurationExtension",
                infoPlist: "Extensions/ShieldActionConfigurationExtension/Info.plist",
                entitlements: "Extensions/ShieldActionConfigurationExtension/ShieldActionConfigurationExtension.entitlements",
                dependencies: [
                    .domain,
                    .feature(interface: .AppGroupFeature),
                    .feature(implements: .AppGroupFeature)
                ],
                settings: Project.Environment.projectSettings
            )
        )
    ]
)
