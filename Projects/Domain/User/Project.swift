//
//  Project.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 6/22/25.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "\(ModulePath.Domain.name)_\(ModulePath.Domain.User.rawValue)",
    targets: [
        .domain(
            interface: .User,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
        .domain(
            implements: .User,
            factory: .init(
                dependencies: [
                    .domain(interface: .User),
                ]
            )
        ),
        .domain(
            testing: .User,
            factory: .init(
                dependencies: [
                    .domain(interface: .User),
                ]
            )
        ),
        .domain(tests: .User, factory: .init(
            dependencies: [
                .domain(testing: .User)
            ]
        ))
    ]
)
