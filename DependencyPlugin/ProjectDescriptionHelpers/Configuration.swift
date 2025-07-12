//
//  Configuration.swift
//  Manifests
//
//  Created by Derrick kim on 7/6/25.
//

import ProjectDescription

extension Configuration {
    public static func build(
        _ type: ProjectDeploymentTarget
    ) -> Self {
        switch type {
        case .dev:
            return .debug(
                name: type.configurationName,
                xcconfig: .relativeToXCConfig(target: .dev)
            )
        case .prod:
            return .release(
                name: type.configurationName,
                xcconfig: .relativeToXCConfig(target: .prod)
            )
        }
    }
}
