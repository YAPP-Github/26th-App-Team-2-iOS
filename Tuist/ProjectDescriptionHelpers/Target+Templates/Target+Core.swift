//
//  Target+Core.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 8/1/25.
//

import ProjectDescription
import DependencyPlugin

// MARK: -- Target + Core
public extension Target {
    static func core(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name
        return make(factory: newFactory)
    }

    static func core(implements module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue
        newFactory.sources = .sources

        return make(factory: newFactory)
    }

    static func core(tests module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Tests"
        newFactory.product = .unitTests
        newFactory.sources = .tests
        
        if module == .LocalStorage {
            newFactory.bundleId = "com.brake.app.CoreLocalStorageTests"
        }

        return make(factory: newFactory)
    }

    static func core(testing module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Testing"
        newFactory.sources = .testing

        return make(factory: newFactory)
    }

    static func core(interface module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Interface"
        newFactory.sources = .interface

        return make(factory: newFactory)
    }

    static func core(
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
    
    // Example용 Extension (Core 모듈에서 사용)
    static func core(
        shieldConfigurationExtension module: ModulePath.Core,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = !factory.name.isEmpty ? factory.name : ModulePath.Core.name + module.rawValue + "ShieldConfigurationExtension"
        newFactory.sources = .shieldConfigurationExtensionSources
        newFactory.product = .appExtension
        // Example용 bundle ID 사용
        newFactory.bundleId = !factory.bundleId.isEmpty ? factory.bundleId : "\(Project.Environment.bundlePrefix).\(module.rawValue.lowercased()).example.ShieldConfigurationExtension"
        newFactory.settings = Project.Environment.projectSettings
        newFactory.resources = ["Extensions/ShieldConfigurationExtension/Sources/Images.xcassets/**"]

        return make(factory: newFactory)
    }
    
    static func core(
        shieldConfigurationExtension module: ModulePath.Core,
        deploymentTarget: ProjectDeploymentTarget,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = !factory.name.isEmpty ? factory.name : ModulePath.Core.name + module.rawValue + "ShieldConfigurationExtension"
        newFactory.sources = .shieldConfigurationExtensionSources
        newFactory.product = .appExtension
        newFactory.resources = ["Extensions/ShieldConfigurationExtension/Sources/Images.xcassets/**"]
        newFactory.bundleId = "\(Project.Environment.bundlePrefix).\(module.rawValue.lowercased()).example.ShieldConfigurationExtension"
        newFactory.settings = Project.Environment.projectSettings

        return make(factory: newFactory)
    }

    static func core(
        shieldActionConfigurationExtension module: ModulePath.Core,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = !factory.name.isEmpty ? factory.name : ModulePath.Core.name + module.rawValue + "ShieldActionConfigurationExtension"
        newFactory.sources = .shieldActionConfigurationExtensionSources
        newFactory.product = .appExtension
        // Example용 bundle ID 사용
        newFactory.bundleId = !factory.bundleId.isEmpty ? factory.bundleId : "\(Project.Environment.bundlePrefix).\(module.rawValue.lowercased()).example.ShieldActionConfigurationExtension"
        newFactory.settings = Project.Environment.projectSettings

        return make(factory: newFactory)
    }
    
    static func core(
        shieldActionConfigurationExtension module: ModulePath.Core,
        deploymentTarget: ProjectDeploymentTarget,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = !factory.name.isEmpty ? factory.name : ModulePath.Core.name + module.rawValue + "ShieldActionConfigurationExtension"
        newFactory.sources = .shieldActionConfigurationExtensionSources
        newFactory.product = .appExtension
        newFactory.bundleId = "\(Project.Environment.bundlePrefix).\(module.rawValue.lowercased()).example.ShieldActionConfigurationExtension"
        newFactory.settings = Project.Environment.projectSettings

        return make(factory: newFactory)
    }

    static func core(
        deviceActivityMonitorExtension module: ModulePath.Core,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = !factory.name.isEmpty ? factory.name : ModulePath.Core.name + module.rawValue + "DeviceActivityMonitorExtension"
        newFactory.sources = .deviceActivityMonitorExtensionSources
        newFactory.product = .appExtension
        newFactory.bundleId = !factory.bundleId.isEmpty ? factory.bundleId : "\(Project.Environment.bundlePrefix).\(module.rawValue.lowercased()).example.DeviceActivityMonitorExtension"
        newFactory.settings = Project.Environment.projectSettings

        return make(factory: newFactory)
    }

}
