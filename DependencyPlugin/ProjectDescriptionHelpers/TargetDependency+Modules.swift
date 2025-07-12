//
//  TargetDependency+Modules.swift
//  26th-App-Team-2-iOSManifests
//
//  Created by Greem on 6/18/25.
//

/// Tuist의 TargetDependency란?
/// TargetDependency는 Tuist에서 각 타겟(Target)이 어떤 다른 타겟, 라이브러리, 프레임워크, 외부 패키지 등에 의존하는지 명시적으로 선언하는 객체입니다. 즉, "이 타겟이 빌드될 때 반드시 함께 빌드되어야 하거나 링크되어야 하는 다른 요소"를 지정하는 역할을 합니다.
/// 주요 특징 및 사용 목적
/// •    프로젝트가 커지고 여러 타겟(모듈)로 분리될수록 각 타겟의 의존성을 명확하게 관리해야 하며, Tuist는 이를 위해 TargetDependency 타입을 사용합니다.
/// •    TargetDependency는 같은 프로젝트 내의 타겟, 다른 프로젝트의 타겟, 바이너리 프레임워크, 라이브러리, 외부 패키지(Swift Package, CocoaPods, Carthage 등) 등 다양한 의존성 형태를 지원합니다.
/// •    의존성 그래프를 명시적이고 정적으로 관리하여, 순환 의존성이나 잘못된 연결을 방지하고, 빌드 최적화 및 검증을 쉽게 할 수 있습니다

import Foundation
import ProjectDescription

// MARK: TargetDependency + App
/// App 모듈에 대한 의존성을 정의하는 확장
public extension TargetDependency {
    /// 기본 App 모듈에 대한 의존성을 반환
    static var app: Self {
        return .project(target: ModulePath.App.name, path: .app)
    }
    
    /// 특정 App 모듈 구현체에 대한 의존성을 반환
    /// - Parameter module: 구현할 App 모듈
    static func app(implements module: ModulePath.App) -> Self {
        return .target(name: ModulePath.App.name + module.rawValue)
    }
}

// MARK: TargetDependency + Feature
/// Feature 모듈에 대한 의존성을 정의하는 확장
public extension TargetDependency {
    /// 기본 Feature 모듈에 대한 의존성을 반환
    static var feature: Self {
        return .project(target: ModulePath.Feature.name, path: .feature)
    }
    
    /// 특정 Feature 모듈 구현체에 대한 의존성을 반환
    /// - Parameter module: 구현할 Feature 모듈
    static func feature(implements module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue, path: .feature(implementation: module))
    }
    
    /// 특정 Feature 모듈의 인터페이스에 대한 의존성을 반환
    /// - Parameter module: 인터페이스를 가져올 Feature 모듈
    static func feature(interface module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Interface", path: .feature(implementation: module))
    }
    
    /// 특정 Feature 모듈의 테스트에 대한 의존성을 반환
    /// - Parameter module: 테스트할 Feature 모듈
    static func feature(tests module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Tests", path: .feature(implementation: module))
    }
    
    /// 특정 Feature 모듈의 테스팅 유틸리티에 대한 의존성을 반환
    /// - Parameter module: 테스팅 유틸리티를 가져올 Feature 모듈
    static func feature(testing module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Testing", path: .feature(implementation: module))
    }
}

// MARK: TargetDependency + Domain
/// Domain 모듈에 대한 의존성을 정의하는 확장
public extension TargetDependency {
    /// 기본 Domain 모듈에 대한 의존성을 반환
    static var domain: Self {
        return .project(target: ModulePath.Domain.name, path: .domain)
    }
    
    /// 특정 Domain 모듈 구현체에 대한 의존성을 반환
    /// - Parameter module: 구현할 Domain 모듈
    static func domain(implements module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue, path: .domain(implementation: module))
    }
    
    /// 특정 Domain 모듈의 인터페이스에 대한 의존성을 반환
    /// - Parameter module: 인터페이스를 가져올 Domain 모듈
    static func domain(interface module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue + "Interface", path: .domain(implementation: module))
    }
    
    /// 특정 Domain 모듈의 테스트에 대한 의존성을 반환
    /// - Parameter module: 테스트할 Domain 모듈
    static func domain(tests module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue + "Tests", path: .domain(implementation: module))
    }
    
    /// 특정 Domain 모듈의 테스팅 유틸리티에 대한 의존성을 반환
    /// - Parameter module: 테스팅 유틸리티를 가져올 Domain 모듈
    static func domain(testing module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue + "Testing", path: .domain(implementation: module))
    }
}

// MARK: TargetDependency + Core
/// Core 모듈에 대한 의존성을 정의하는 확장
public extension TargetDependency {
    /// 기본 Core 모듈에 대한 의존성을 반환
    static var core: Self {
        return .project(target: ModulePath.Core.name, path: .core)
    }
    
    /// 특정 Core 모듈 구현체에 대한 의존성을 반환
    /// - Parameter module: 구현할 Core 모듈
    static func core(implements module: ModulePath.Core) -> Self {
        return .project(target: ModulePath.Core.name + module.rawValue, path: .core(implementation: module))
    }
    
    /// 특정 Core 모듈의 인터페이스에 대한 의존성을 반환
    /// - Parameter module: 인터페이스를 가져올 Core 모듈
    static func core(interface module: ModulePath.Core) -> Self {
        return .project(target: ModulePath.Core.name + module.rawValue + "Interface", path: .core(implementation: module))
    }
    
    /// 특정 Core 모듈의 테스트에 대한 의존성을 반환
    /// - Parameter module: 테스트할 Core 모듈
    static func core(tests module: ModulePath.Core) -> Self {
        return .project(target: ModulePath.Core.name + module.rawValue + "Tests", path: .core(implementation: module))
    }
    
    /// 특정 Core 모듈의 테스팅 유틸리티에 대한 의존성을 반환
    /// - Parameter module: 테스팅 유틸리티를 가져올 Core 모듈
    static func core(testing module: ModulePath.Core) -> Self {
        return .project(target: ModulePath.Core.name + module.rawValue + "Testing", path: .core(implementation: module))
    }
}

// MARK: TargetDependency + Shared
/// Shared 모듈에 대한 의존성을 정의하는 확장
public extension TargetDependency {
    /// 기본 Shared 모듈에 대한 의존성을 반환
    static var shared: Self {
        return .project(target: ModulePath.Shared.name, path: .shared)
    }
    
    /// 특정 Shared 모듈 구현체에 대한 의존성을 반환
    /// - Parameter module: 구현할 Shared 모듈
    static func shared(implements module: ModulePath.Shared) -> Self {
        return .project(target: ModulePath.Shared.name + module.rawValue, path: .shared(implementation: module))
    }
}
