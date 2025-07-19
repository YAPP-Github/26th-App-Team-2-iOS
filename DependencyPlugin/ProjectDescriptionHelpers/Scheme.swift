//
//  Scheme.swift
//  Manifests
//
//  Created by Derrick kim on 7/6/25.
//

import ProjectDescription

extension Scheme {
    /// Creates a `Scheme` configured for the specified deployment target and project name.
    /// - Parameters:
    ///   - type: The deployment target type (e.g., debug, release).
    ///   - name: The base name of the project.
    /// - Returns: A `Scheme` with actions and target names adjusted according to the deployment target. For `.debug`, the scheme and target names include the deployment target's raw value as a suffix; otherwise, the base name is used. All actions use the configuration associated with the deployment target.
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
