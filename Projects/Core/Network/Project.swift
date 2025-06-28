//
//  Project.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 6/22/25.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    /// 인터페이스
    .core(
        interface: .Network,
        factory: .init(
            dependencies: [
                .shared
            ]
        )
    ),
    /// 네트워크
    .core(
        implements: .Network,
        factory: .init(
            dependencies: [
                .core(interface: .Network),
                .shared
            ]
        )
    ),
    /// 테스트
    .core(
        tests: .Network,
        factory: .init(
            dependencies: [
                .core(testing: .Network),
                
            ]
        )
    ),
    /// 테스팅
    .core(
        testing: .Network,
        factory: .init(
            dependencies: [
                .core(interface: .Network),
                .core(implements: .Network)
            ]
        )
    )
]




let project: Project = .makeModule(
    name: "\(ModulePath.Core.name)_\(ModulePath.Core.Network.rawValue)",
    targets: targets
)
