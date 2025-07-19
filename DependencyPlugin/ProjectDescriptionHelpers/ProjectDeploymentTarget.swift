//
//  ProjectDeploymentTarget.swift
//  Manifests
//
//  Created by Derrick kim on 7/6/25.
//

import ProjectDescription

public enum ProjectDeploymentTarget: String {
    case debug = "Debug"
    case release = "Release"
    
    public var configurationName: ConfigurationName {
        return ConfigurationName.configuration(self.rawValue)
    }
}
