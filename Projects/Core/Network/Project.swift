//
//  Project.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 6/22/25.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .core(
        interface: .Network,
        factory: .init(
            dependencies: [
                .shared
            ]
        )
    ),
    .core(
        implements: .Network,
        factory: .init(
            dependencies: [
                .core(interface: .Network),
                .shared
            ]
        )
    ),
    .core(
        tests: .Network,
        factory: .init(
            dependencies: [
                .core(testing: .Network)
            ]
        )
    ),
    .core(
        testing: .Network,
        factory: .init(
            dependencies: [
                .core(interface: .Network)
            ]
        )
    )
]
let project: Project = .makeModule(
    name: "\(ModulePath.Core.name)_\(ModulePath.Core.Network.rawValue)",
    targets: targets
)
