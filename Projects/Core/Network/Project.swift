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
                .core(interface: .Network)
            ]
        )
    ),
    .core(
        testing: .Network,
        factory: .init(
            dependencies: [
                .core(interface: .Network),
                .core(implements: .Network)
            ]
        )
    ),
    .core(
        tests: .Network,
        factory: .init(
            dependencies: [
                .core(interface: .Network),
                .core(testing: .Network),
                .core(implements: .Network)
            ]
        )
    )
    
]
let project: Project = .makeModule(
    name: ModulePath.Core.name + ModulePath.Core.Network.rawValue,
    targets: targets
)
