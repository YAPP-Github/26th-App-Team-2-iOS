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
    .shared(factory: .init(
        dependencies: [
            .shared(implements: .Util)
        ]
    ))
]

let project: Project = .makeModule(
    name: "Shared",
    targets: targets
)
