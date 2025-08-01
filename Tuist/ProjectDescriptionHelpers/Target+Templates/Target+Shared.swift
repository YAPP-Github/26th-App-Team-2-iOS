//
//  Target+Shared.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 8/1/25.
//

import ProjectDescription
import DependencyPlugin

// MARK: Target + Shared
public extension Target {
    static func shared(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Shared.name
        newFactory.sources = .sources

        return make(factory: newFactory)
    }

    static func shared(implements module: ModulePath.Shared, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Shared.name + module.rawValue
        newFactory.sources = .sources

        if module == .DesignSystem {
            newFactory.product = .staticFramework
            newFactory.resources = ["Resources/**"]
        }

        return make(factory: newFactory)
    }

    static func shared(
        example module: ModulePath.Shared,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Shared.name + module.rawValue + "Example"
        newFactory.sources = .exampleSources
        newFactory.product = .app
        newFactory.bundleId = !factory.bundleId.isEmpty ? factory.bundleId : "\(Project.Environment.bundlePrefix).\(module.rawValue.lowercased()).example"
        newFactory.settings = Project.Environment.exampleTargetSettings

        return make(factory: newFactory)
    }


}
