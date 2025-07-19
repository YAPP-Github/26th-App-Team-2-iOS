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
        factory: .init(
            dependencies: [
                .shared(implements: .Util),
                .shared(implements: .DesignSystem),
                .shared(implements: .ThirdParty)
            ],
            settings: .settings(configurations: [
                .build(.debug),
                .build(.release)
            ],
            defaultSettings: .recommended
            )
        ))
]

let project: Project = .makeModule(
    name: "Shared",
    targets: targets
)
