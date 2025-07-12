//
//  Scheme.swift
//  Manifests
//
//  Created by Derrick kim on 7/6/25.
//

import ProjectDescription

extension Scheme {
    public static func makeScheme(_ type: ProjectDeploymentTarget, name: String) -> Self {
        return .scheme(
            name: "\(name)-\(type.rawValue)",
            buildAction: .buildAction(targets: ["\(name)-\(type.rawValue)"]),
            runAction: .runAction(configuration: type.configurationName),
            archiveAction: .archiveAction(configuration: type.configurationName),
            profileAction: .profileAction(configuration: type.configurationName),
            analyzeAction: .analyzeAction(configuration: type.configurationName)
        )
    }
}
