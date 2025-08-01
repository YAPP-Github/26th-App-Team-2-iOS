//
//  Target+Domain.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 8/1/25.
//

import ProjectDescription
import DependencyPlugin

// MARK: -- Target + Domain
public extension Target {
    static func domain(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name
        
        return make(factory: newFactory)
    }

    static func domain(implements module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue
        newFactory.sources = .sources

        return make(factory: newFactory)
    }

    static func domain(interface module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Interface"
        newFactory.sources = .interface

        return make(factory: newFactory)
    }

    static func domain(tests module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Tests"
        newFactory.product = .unitTests
        newFactory.sources = .tests

        return make(factory: newFactory)
    }

    static func domain(testing module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Testing"
        newFactory.sources = .testing

        return make(factory: newFactory)
    }
}
