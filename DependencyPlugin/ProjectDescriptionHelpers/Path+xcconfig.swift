//
//  Path+xcconfig.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 7/6/25.
//

import ProjectDescription

extension Path {
    public static func relativeToXCConfig(target: ProjectDeploymentTarget) -> Self {
        return .relativeToRoot("./Projects/App/xcconfigs/\(target.rawValue).xcconfig")
    }
}

