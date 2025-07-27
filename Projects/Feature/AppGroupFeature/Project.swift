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
                    .domain,
                    .sdk(name: "FamilyControls", type: .framework, status: .required),
                    .sdk(name: "ManagedSettings", type: .framework, status: .required)
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
                    .feature(interface: .AppGroupFeature)
                ]
            )
        ),
        .feature(
            tests: .AppGroupFeature,
            factory: .init(
                dependencies: [
                    .feature(testing: .AppGroupFeature)
                ]
            )
        ),

        .feature(
            example: .AppGroupFeature,
            factory: .init(
                infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .debug),
                dependencies: [
                    .feature(interface: .AppGroupFeature)
                ]
            )
        )
    ]
)
