//
//  Project+Environment.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 6/18/25.
//

import Foundation
import ProjectDescription

public extension Project {
    enum Environment {
        
        public static let appName = "Brake"
        public static let deploymentTarget = DeploymentTargets.iOS("17.0")
        
        /// 앱 번들, 추후 변경사항
        public static let bundlePrefix = "com.example.app2"
    }
}
