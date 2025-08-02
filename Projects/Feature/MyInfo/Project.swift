//
//  Project.swift
//  Brake
//
//  Created by Derrick kim on 2025/08/02.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name+ModulePath.Feature.MyInfo.rawValue,
    targets: [
        .feature(
            interface: .MyInfo,
            factory: .init(
                dependencies: [
                    .domain
                ]
            )
        ),
        .feature(
            implements: .MyInfo,
            factory: .init(
                dependencies: [
                    .feature(interface: .MyInfo)
                ]
            )
        ),
        .feature(
            testing: .MyInfo,
            factory: .init(
                dependencies: [
                    .feature(implements: .MyInfo)
                ]
            )
        ),
        .feature(
            tests: .MyInfo,
            factory: .init(
                dependencies: [
                    .feature(testing: .MyInfo)
                ]
            )
        ),
        .feature(
            example: .MyInfo,
            factory: .init(
                infoPlist: Project.Environment.appInfoPlist(
                    deploymentTarget: .debug
                ),
                scripts: Project.Environment.appScripts,
                dependencies: [
                    .feature(implements: .MyInfo)
                ],
                settings: Project.Environment.exampleTargetSettings
            )
        )

    ]
)
