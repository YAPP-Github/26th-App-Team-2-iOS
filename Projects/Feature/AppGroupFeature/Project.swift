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
                    .feature(interface: .AppGroupFeature)
                ]
            )
        )
    ]
)
