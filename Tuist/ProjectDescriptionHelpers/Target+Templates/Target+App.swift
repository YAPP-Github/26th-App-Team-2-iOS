//
//  Target+App.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 8/1/25.
//

import ProjectDescription
import DependencyPlugin

// MARK: -- Target + App
public extension Target {
    static func app(
        implements module: ModulePath.App,
        deploymentTarget: ProjectDeploymentTarget,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.App.name + module.rawValue
        
        switch module {
        case .iOS:
            newFactory.product = .app
            newFactory.name = Project.Environment.targetName(deploymentTarget: deploymentTarget)
            newFactory.bundleId = Project.Environment.bundleId(deploymentTarget: deploymentTarget)
            newFactory.resources = ["Resources/**", "Resources/PrivacyInfo.xcprivacy"]
            newFactory.productName = Project.Environment.targetName(deploymentTarget: deploymentTarget)
            newFactory.sources = .sources
            newFactory.entitlements = "\(Project.Environment.appName).entitlements"
            newFactory.dependencies = factory.dependencies
        case .DeviceActivityMonitorExtension:
            newFactory.product = .appExtension
            newFactory.name = "\(Project.Environment.appName)DeviceActivityMonitorExtension-\(deploymentTarget.rawValue.capitalized)"
            newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: deploymentTarget)).DeviceActivityMonitorExtension"
            newFactory.sources = .mainAppDeviceActivityMonitorExtensionSources
            newFactory.resources = ["Extensions/DeviceActivityMonitorExtension/PrivacyInfo.xcprivacy"]
            newFactory.entitlements = "Extensions/DeviceActivityMonitorExtension/BrakeDeviceActivityMonitorExtension.entitlements"
            newFactory.infoPlist = .file(path: "Extensions/DeviceActivityMonitorExtension/Info.plist")
        case .NotificationExtension:
            newFactory.product = .appExtension
            newFactory.name = "\(Project.Environment.appName)NotificationExtension-\(deploymentTarget.rawValue.capitalized)"
            newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: deploymentTarget)).notification"
            newFactory.resources = ["Resources/**"]
            newFactory.sources = .notificationExtensionSources
        case .ShieldConfigurationExtension:
            newFactory.product = .appExtension
            newFactory.name = "\(Project.Environment.appName)ShieldConfigurationExtension-\(deploymentTarget.rawValue.capitalized)"
            newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: deploymentTarget)).ShieldConfigurationExtension"
            newFactory.sources = .mainAppShieldConfigurationExtensionSources
            newFactory.resources = ["Extensions/ShieldConfigurationExtension/Resources/Images.xcassets/**", "Extensions/ShieldConfigurationExtension/PrivacyInfo.xcprivacy"]
            newFactory.infoPlist = .file(path: "Extensions/ShieldConfigurationExtension/Info.plist")
            newFactory.entitlements = "Extensions/ShieldConfigurationExtension/BrakeShieldConfigurationExtension.entitlements"
        case .ShieldActionConfigurationExtension:
            newFactory.product = .appExtension
            newFactory.name = "\(Project.Environment.appName)ShieldActionConfigurationExtension-\(deploymentTarget.rawValue.capitalized)"
            newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: deploymentTarget)).ShieldActionConfigurationExtension"
            newFactory.sources = .mainAppShieldActionConfigurationExtensionSources
            newFactory.resources = ["Extensions/ShieldActionConfigurationExtension/PrivacyInfo.xcprivacy"]
            newFactory.infoPlist = .file(path: "Extensions/ShieldActionConfigurationExtension/Info.plist")
            newFactory.entitlements = "Extensions/ShieldActionConfigurationExtension/BrakeShieldActionConfigurationExtension.entitlements"
        }

        return .make(factory: newFactory)
    }
    
    static func app(
        implements module: ModulePath.App,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.App.name + module.rawValue
        
        switch module {
        case .iOS:
            fallthrough
        case .NotificationExtension:
            newFactory.product = .appExtension
            newFactory.name = factory.name.isEmpty ? "\(Project.Environment.appName)NotificationExtension" : factory.name
            newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: .debug)).notification"
            newFactory.sources = .notificationExtensionSources
            newFactory.resources = ["Resources/**", "Extensions/NotificationExtension/PrivacyInfo.xcprivacy"]
        case .ShieldConfigurationExtension:
            newFactory.product = .appExtension
            newFactory.name = factory.name.isEmpty ? "\(Project.Environment.appName)ShieldConfigurationExtension" : factory.name
            newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: .debug)).ShieldConfigurationExtension"
            newFactory.sources = .shieldConfigurationExtensionSources
            newFactory.resources = ["Extensions/ShieldConfigurationExtension/Resources/Images.xcassets/**", "Extensions/ShieldConfigurationExtension/PrivacyInfo.xcprivacy"]
        case .ShieldActionConfigurationExtension:
            newFactory.product = .appExtension
            newFactory.name = factory.name.isEmpty ? "\(Project.Environment.appName)ShieldActionConfigurationExtension" : factory.name
            newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: .debug)).ShieldActionConfigurationExtension"
            newFactory.sources = .shieldActionConfigurationExtensionSources
            newFactory.resources = ["Extensions/ShieldActionConfigurationExtension/PrivacyInfo.xcprivacy"]
        case .DeviceActivityMonitorExtension:
            newFactory.product = .appExtension
            newFactory.name = factory.name.isEmpty ? "\(Project.Environment.appName)DeviceActivityMonitorExtension" : factory.name
            newFactory.bundleId = "\(Project.Environment.bundleId(deploymentTarget: .debug)).DeviceActivityMonitorExtension"
            newFactory.sources = .mainAppDeviceActivityMonitorExtensionSources
            newFactory.resources = ["Extensions/DeviceActivityMonitorExtension/PrivacyInfo.xcprivacy"]
            newFactory.entitlements = "Extensions/DeviceActivityMonitorExtension/BrakeDeviceActivityMonitorExtension.entitlements"
            newFactory.infoPlist = "Extensions/DeviceActivityMonitorExtension/Info.plist"
        }

        return .make(factory: newFactory)
    }
    
    static func app(tests module: ModulePath.App, factory: TargetFactory) -> Self {
        let deploymentTarget = ProjectDeploymentTarget.debug
        var newFactory = factory
        newFactory.name = ModulePath.App.name + module.rawValue + "Tests"
        newFactory.product = .unitTests
        newFactory.productName = nil  // 단위 테스트는 productName이 필요 없음
        
        let bundleId: String = if deploymentTarget == .debug {
            "\(Project.Environment.bundlePrefix).\(deploymentTarget.rawValue)"
        } else {
            Project.Environment.bundlePrefix
        }
        
        switch module {
        case .iOS:
            newFactory.destinations = .iOS
            newFactory.name = Project.Environment.appName + "-\(deploymentTarget.rawValue)-Tests"
            newFactory.bundleId = "\(bundleId).tests"
            newFactory.sources = .tests
            newFactory.resources = .resources(["Resources/**"])
        case .NotificationExtension:
            newFactory.destinations = .iOS
            newFactory.name = "\(Project.Environment.appName)-\(deploymentTarget.rawValue)-NotificationExtension-Tests"
            newFactory.bundleId = "\(Project.Environment.bundlePrefix).\(deploymentTarget.rawValue).notification.tests"
            newFactory.sources = .tests
            newFactory.resources = .resources(["Resources/**"])
        case .ShieldConfigurationExtension:
            newFactory.destinations = .iOS
            newFactory.name = "\(Project.Environment.appName)-\(deploymentTarget.rawValue)-ShieldConfigurationExtension-Tests"
            newFactory.bundleId = "\(Project.Environment.bundlePrefix).\(deploymentTarget.rawValue).ShieldConfigurationExtension.tests"
            newFactory.sources = .tests
        case .ShieldActionConfigurationExtension:
            newFactory.destinations = .iOS
            newFactory.name = "\(Project.Environment.appName)-\(deploymentTarget.rawValue)-ShieldActionConfigurationExtension-Tests"
            newFactory.bundleId = "\(Project.Environment.bundlePrefix).\(deploymentTarget.rawValue).ShieldActionConfigurationExtension.tests"
            newFactory.sources = .tests
        case .DeviceActivityMonitorExtension:
            newFactory.destinations = .iOS
            newFactory.name = "\(Project.Environment.appName)-\(deploymentTarget.rawValue)-DeviceActivityMonitorExtension-Tests"
            newFactory.bundleId = "\(Project.Environment.bundlePrefix).\(deploymentTarget.rawValue).DeviceActivityMonitorExtension.tests"
            newFactory.sources = .tests
        }
        
        return .make(factory: newFactory)
    }
}
