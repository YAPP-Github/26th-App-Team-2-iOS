//
//  ProjectDeploymentTarget.swift
//  Manifests
//
//  Created by Derrick kim on 7/6/25.
//

import ProjectDescription

public enum ProjectDeploymentTarget: String {
	case dev = "DEV"
	case prod = "PROD"
    
    public var configurationName: ConfigurationName {
        return ConfigurationName.configuration(self.rawValue)
    }
}
