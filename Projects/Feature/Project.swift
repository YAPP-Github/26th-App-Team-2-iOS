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
    .feature(
        factory: .init(
            dependencies: [
                .domain,
                .feature(implements: .Onboarding)
            ],
            settings: .settings(configurations: [
                .build(.debug),
                .build(.release)
            ])
        )
    )
]

let project: Project = .makeModule(name: "Feature", targets: targets)
