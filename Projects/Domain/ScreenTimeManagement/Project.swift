//
//  Project.swift
//  Brake
//
//  Created by Derrick kim on 2025/07/31.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.ScreenTimeManagement.rawValue,
    targets: [
        .domain(
            interface: .ScreenTimeManagement,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
        .domain(
            implements: .ScreenTimeManagement,
            factory: .init(
                dependencies: [
                    .domain(interface: .ScreenTimeManagement)
                ]
            )
        ),
        .domain(
            testing: .ScreenTimeManagement,
            factory: .init(
                dependencies: [
                    .domain(interface: .ScreenTimeManagement)
                ]
            )
        ),
        .domain(
            tests: .ScreenTimeManagement,
            factory: .init(
                dependencies: [
                    .domain(testing: .ScreenTimeManagement)
                ]
            )
        ),

    ]
)
