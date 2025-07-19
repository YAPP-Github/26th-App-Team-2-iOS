//
//  Configuration.swift
//  Manifests
//
//  Created by Derrick kim on 7/6/25.
//

import ProjectDescription

extension Configuration {
    /// Creates a `Configuration` instance based on the specified deployment target.
    /// - Parameter type: The deployment target for which to build the configuration.
    /// - Returns: A `Configuration` corresponding to the given deployment target, with appropriate name and xcconfig settings.
    public static func build(
        _ type: ProjectDeploymentTarget
    ) -> Self {
        switch type {
        case .debug:
            return .debug(
                name: type.configurationName,
                xcconfig: .relativeToXCConfig(target: type)
            )
        case .release:
            return .release(
                name: type.configurationName,
                xcconfig: .relativeToXCConfig(target: type)
            )
        }
    }
}
