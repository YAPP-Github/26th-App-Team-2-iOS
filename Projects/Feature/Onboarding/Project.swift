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
        factory: .init(
            dependencies: [
        factory: .init(
            dependencies: [
            .domain
        ])
    ),
    .feature(
        implements: .Onboarding,
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
    ),
    .feature(
        example: .Onboarding,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(
                deploymentTarget: .debug,
                bundleID: "\(Project.Environment.bundleId(deploymentTarget: .debug))-\(ModulePath.Feature.Onboarding.rawValue)"
            ),
            entitlements: "\(Project.Environment.appName).entitlements",
            dependencies: [
                .feature(interface: .Onboarding),
                .feature(implements: .Onboarding)
            ],
            settings: Project.Environment.exampleTargetSettings
        )
    )
]

let project: Project = .makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Onboarding.rawValue,
    targets: targets
) 
