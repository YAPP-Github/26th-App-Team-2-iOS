//
//  Project.swift
//  Brake
//
//  Created by Greem on 2025/07/22.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.OAuth.rawValue,
    targets: [
        .domain(
            interface: .OAuth,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
        .domain(
            implements: .OAuth,
            factory: .init(
                dependencies: [
                    .domain(interface: .OAuth)
                ]
            )
        ),

        .domain(
            testing: .OAuth,
            factory: .init(
                dependencies: [
                    .domain(interface: .OAuth)
                ]
            )
        ),
        .domain(
            tests: .OAuth,
            factory: .init(
                dependencies: [
                    .domain(testing: .OAuth)
                ]
            )
        ),

    ]
)
