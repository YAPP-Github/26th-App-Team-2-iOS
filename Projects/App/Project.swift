//
//  Project.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 6/18/25.
//

import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let targets: [Target] = [
    .app(
        impletments: .IOS,
        factory: .init(
            infoPlist: .default,
            entitlements: .variable("App2.entitlements"),
            dependencies: [
//                .feature
            ]
        )
    )
]

let project: Project = .makeModule(name: "App2", targets: targets)

