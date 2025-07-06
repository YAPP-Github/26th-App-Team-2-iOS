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
    .shared(
        implements: .Util,
        factory: .init()
    )
]

let project: Project = .makeModule(
    name: ModulePath.Shared.name + ModulePath.Shared.Util.rawValue,
    targets: targets
)
