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
