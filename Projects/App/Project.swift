//
//  Project.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 6/18/25.
//

import Foundation
import ProjectDescription
import DependencyPlugin

//let project = Project(targets: .)

let project = Project(
    name: "app2",
    targets: [
        
        .target(
            name: "26thAppTeam2IOS",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.26thAppTeam2IOS",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["26thAppTeam2IOS/Sources/**"],
            resources: ["26thAppTeam2IOS/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "26thAppTeam2IOSTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.26thAppTeam2IOSTests",
            infoPlist: .default,
            sources: ["26thAppTeam2IOS/Tests/**"],
            resources: [],
            dependencies: [.target(name: "26thAppTeam2IOS")]
        ),
    ]
)

