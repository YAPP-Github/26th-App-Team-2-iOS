//
//  Project.swift
//  Brake
//
//  Created by Derrick kim on 2025/07/09.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name+ModulePath.Core.LocalStorage.rawValue,
    targets: [
        .core(
            interface: .LocalStorage,
            factory: .init(
                dependencies: [
                    .shared
                ]
            )
        ),
        .core(
            implements: .LocalStorage,
            factory: .init(
                dependencies: [
                    .core(interface: .LocalStorage)
                ]
            )
        ),
        .core(
            testing: .LocalStorage,
            factory: .init(
                dependencies: [
                    .core(interface: .LocalStorage)
                ]
            )
        ),
        .core(
            tests: .LocalStorage,
            factory: .init(
                dependencies: [
                    .core(testing: .LocalStorage),
                    .core(implements: .LocalStorage),
                    .core(interface: .LocalStorage)
                ]
            )
        ),

    ]
)
