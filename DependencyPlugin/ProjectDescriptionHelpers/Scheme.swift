//
//  Scheme.swift
//  Manifests
//
//  Created by Derrick kim on 7/6/25.
//

import ProjectDescription

extension Scheme {
    public static func makeScheme(_ type: ProjectDeploymentTarget, name: String) -> Self {
        let schemeName: String = type == .debug ? "\(name)-\(type.rawValue)" : name
        let targetName: String = type == .debug ? "\(name)-\(type.rawValue)" : name
        return .scheme(
            name: schemeName,
            buildAction: .buildAction(targets: ["\(targetName)"]),
            runAction: .runAction(configuration: type.configurationName),
            archiveAction: .archiveAction(configuration: type.configurationName),
            profileAction: .profileAction(configuration: type.configurationName),
            analyzeAction: .analyzeAction(configuration: type.configurationName)
        )
    }
}
