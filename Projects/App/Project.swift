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
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1",
                "CFBundleVersion": "1",
                "CFBundleName": "Brake",
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": []
                ]
            ]),
            entitlements: .variable("Brake.entitlements"),
            dependencies: [
                .feature
            ]
        )
    )
]

let project: Project = .makeModule(name: "Brake", targets: targets)

