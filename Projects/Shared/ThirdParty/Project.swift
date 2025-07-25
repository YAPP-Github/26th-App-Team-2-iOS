//
//  Project.swift
//  Brake
//
//  Created by Greem on 2025/07/12.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Shared.name+ModulePath.Shared.ThirdParty.rawValue,
    targets: [
        .shared(
            implements: .ThirdParty,
            factory: .init(
                dependencies: [
                    .external(name: "FirebaseAnalytics"),
                    .external(name: "FirebaseCrashlytics"),
                    .sdk(name: "WebKit", type: .framework, status: .required)
                ],
                settings: .settings(configurations: [
                    .build(.debug),
                    .build(.release)
                ])
            )
        )

    ]
)
