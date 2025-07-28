//
//  Project.swift
//  Brake
//
//  Created by Greem on 2025/07/28.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Shared.rawValue,
    targets: [
        .domain(
            interface: .Shared,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
        .domain(
            implements: .Shared,
            factory: .init(
                dependencies: [
                    .domain(interface: .Shared)
                ]
            )
        )
    ]
)
