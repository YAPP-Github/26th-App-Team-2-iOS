//
//  Target+Feature.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 8/1/25.
//

import ProjectDescription
import DependencyPlugin

// MARK: -- Target + Feature
public extension Target {
    static func feature(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name

        return make(factory: newFactory)
    }

    static func feature(implements module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue
        return make(factory: newFactory)
    }

    static func feature(interface module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Interface"
        newFactory.sources = .interface
        newFactory.product = Environment.forPreview.getBoolean(default: false) ? .framework : .staticLibrary

        return make(factory: newFactory)
    }

    static func feature(tests module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Tests"
        newFactory.product = .unitTests

        return make(factory: newFactory)
    }
    static func feature(testing module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Testing"
        newFactory.sources = .testing

        return make(factory: newFactory)
    }

    static func feature(example module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Example"
        newFactory.sources = .exampleSources
        newFactory.product = .app
        newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: .debug))-\(module.rawValue)"
        newFactory.settings = Project.Environment.exampleTargetSettings
        return make(factory: newFactory)
    }
    
    
    
    static func feature(
        example module: ModulePath.Core,
        deploymentTarget: ProjectDeploymentTarget,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Example"
        newFactory.sources = .exampleSources
        newFactory.product = .app
        // Ensure the bundle ID matches the extension bundle IDs
        newFactory.bundleId = !factory.bundleId.isEmpty ? factory.bundleId : "\(Project.Environment.bundlePrefix).\(module.rawValue.lowercased()).example"
        newFactory.settings = Project.Environment.debugTargetSettings

        return make(factory: newFactory)
    }
    
    // Example용 Extension (Feature 모듈에서 사용)
    static func feature(
        shieldConfigurationExtension module: ModulePath.Feature,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = !factory.name.isEmpty ? factory.name : ModulePath.Feature.name + module.rawValue + "ShieldConfigurationExtension"
        newFactory.sources = .shieldConfigurationExtensionSources
        newFactory.product = .appExtension
        // Example용 bundle ID 사용
        
        newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: .debug))-\(module.rawValue).ShieldConfigurationExtension"
        newFactory.settings = Project.Environment.projectSettings
        newFactory.resources = ["Extensions/ShieldConfigurationExtension/Resources/Images.xcassets/**"]

        return make(factory: newFactory)
    }
    
    static func feature(
        shieldConfigurationExtension module: ModulePath.Feature,
        deploymentTarget: ProjectDeploymentTarget,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = !factory.name.isEmpty ? factory.name : ModulePath.Feature.name + module.rawValue + "ShieldConfigurationExtension"
        newFactory.sources = .shieldConfigurationExtensionSources
        newFactory.product = .appExtension
        newFactory.resources = ["Extensions/ShieldConfigurationExtension/Resources/Images.xcassets/**"]
        newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: .debug))-\(module.rawValue).ShieldConfigurationExtension"
        newFactory.settings = Project.Environment.projectSettings

        return make(factory: newFactory)
    }

    static func feature(
        shieldActionConfigurationExtension module: ModulePath.Feature,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = !factory.name.isEmpty ? factory.name : ModulePath.Feature.name + module.rawValue + "ShieldActionConfigurationExtension"
        newFactory.sources = .shieldActionConfigurationExtensionSources
        newFactory.product = .appExtension
        // Example용 bundle ID 사용
        newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: .debug))-\(module.rawValue).ShieldActionConfigurationExtension" 
        newFactory.settings = Project.Environment.projectSettings

        return make(factory: newFactory)
    }
    
    static func feature(
        shieldActionConfigurationExtension module: ModulePath.Feature,
        deploymentTarget: ProjectDeploymentTarget,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = !factory.name.isEmpty ? factory.name : ModulePath.Feature.name + module.rawValue + "ShieldActionConfigurationExtension"
        newFactory.sources = .shieldActionConfigurationExtensionSources
        newFactory.product = .appExtension
        newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: .debug))-\(module.rawValue).ShieldActionConfigurationExtension"
        newFactory.settings = Project.Environment.projectSettings

        return make(factory: newFactory)
    }

    static func feature(
        deviceActivityMonitorExtension module: ModulePath.Feature,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = !factory.name.isEmpty ? factory.name : ModulePath.Feature.name + module.rawValue + "DeviceActivityMonitorExtension"
        newFactory.sources = .deviceActivityMonitorExtensionSources
        newFactory.product = .appExtension
        newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: .debug))-\(module.rawValue).DeviceActivityMonitorExtension"
        
        newFactory.settings = Project.Environment.projectSettings

        return make(factory: newFactory)
    }
}
