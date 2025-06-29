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
        interface: .Onboarding,
        factory: .init(dependencies: [
            .domain
        ])
    ),
    .feature(
        impletments: .Onboarding,
        factory: .init(
            dependencies: [
                .feature(interface: .Onboarding)
            ]
        )
    ),
    .feature(
        testing: .Onboarding,
        factory: .init(
            dependencies: [
                .feature(interface: .Onboarding)
            ]
        )
    ),
    .feature(
        tests: .Onboarding,
        factory: .init(
            dependencies: [
                .feature(testing: .Onboarding)
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "\(ModulePath.Feature.name)_\(ModulePath.Feature.Onboarding.rawValue)",
    targets: targets
) 
