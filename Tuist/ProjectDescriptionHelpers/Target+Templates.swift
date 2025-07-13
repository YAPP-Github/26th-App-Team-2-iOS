//
//  Target+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Greem on 6/21/25.
//

import ProjectDescription
import DependencyPlugin

/// tuist 기본 .target 생성자의 생소한 생성자 파라미터
/// 1. buildRules: 특정 파일 확장자 또는 조건에 맞는 사용자 지정 빌드 명령어를 실행하고자 할 때 사용됩니다.
/// 예: .proto, .metal, .graphql 파일 등은 일반적으로 Xcode가 기본적으로 처리하지 않으므로, 별도의 빌드 규칙(build rule)이 필요합니다.
///
///  buildRules: [
///    .init(
///        filePattern: "*.proto",
///        script: "protoc --swift_out=. $SRCROOT/$INPUT_FILE_PATH",
///        outputFiles: ["$(DERIVED_FILE_DIR)/Generated.swift"]
///    )
/// ]
///
/// 2. mergedBinaryType & mergeable
/// 여러 타겟을 하나의 바이너리로 병합하여 빌드 시간을 최적화하거나, 런타임 오버헤드를 줄이고자 할 때 사용됩니다.
/// 예: 여러 기능 모듈이 각각 프레임워크로 존재할 때, 이를 하나의 앱 바이너리로 병합할 수 있습니다.s

public struct TargetFactory {
    var name: String
    var destinations: Destinations
    var product: Product
    var productName: String?
    var bundleId: String
    var deploymentTargets: DeploymentTargets?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var copyFiles: [CopyFilesAction]?
    var headers: Headers?
    var entitlements: Entitlements?
    var scripts: [TargetScript]
    var dependencies: [TargetDependency]
    var settings: Settings?
    var coreDataModels: [CoreDataModel]
    var environmentVariables: [String : EnvironmentVariable]
    var launchArguments: [LaunchArgument]
    var additionalFiles: [FileElement]
    var buildRules: [BuildRule]
    var mergedBinaryType: MergedBinaryType
    var mergeable: Bool
    var onDemandResourcesTags: OnDemandResourcesTags?

    public init(
        name: String = "",
        destinations: Destinations = [.iPhone],
        product: Product = .staticLibrary,
        productName: String? = nil,
        bundleId: String = "",
        deploymentTargets: DeploymentTargets? = Project.Environment.deploymentTarget,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = .sources,
        resources: ResourceFileElements? = nil,
        copyFiles: [CopyFilesAction]? = nil,
        headers: Headers? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings? = Project.Environment.projectSettings,
        coreDataModels: [CoreDataModel] = [],
        environmentVariables: [String : EnvironmentVariable] = [:],
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = [],
        buildRules: [BuildRule] = [],
        mergedBinaryType: MergedBinaryType = .disabled,
        mergeable: Bool = false,
        onDemandResourcesTags: OnDemandResourcesTags? = nil
    ) {
        self.name = name
        self.destinations = destinations
        self.product = product
        self.productName = productName
        self.bundleId = bundleId
        self.deploymentTargets = deploymentTargets
        self.infoPlist = infoPlist
        self.sources = sources
        self.resources = resources
        self.copyFiles = copyFiles
        self.headers = headers
        self.entitlements = entitlements
        self.scripts = scripts
        self.dependencies = dependencies
        self.settings = settings
        self.coreDataModels = coreDataModels
        self.environmentVariables = environmentVariables
        self.launchArguments = launchArguments
        self.additionalFiles = additionalFiles
        self.buildRules = buildRules
        self.mergedBinaryType = mergedBinaryType
        self.mergeable = mergeable
        self.onDemandResourcesTags = onDemandResourcesTags
    }
}

public extension Target {
    private static func make(factory: TargetFactory) -> Self {
        .target(
            name: factory.name,                                   // 타겟의 이름을 지정합니다
            destinations: factory.destinations,                    // 타겟이 실행될 플랫폼을 지정합니다 (iOS, macOS 등)
            product: factory.product,                        // 타겟의 결과물 유형을 지정합니다 (앱, 프레임워크, 라이브러리 등)
            productName: factory.productName,                // 빌드된 결과물의 이름을 지정합니다
            bundleId: factory.bundleId,                      // 앱의 고유 식별자를 지정합니다
            deploymentTargets: factory.deploymentTargets,     // 지원하는 최소 OS 버전을 지정합니다
            infoPlist: factory.infoPlist,                    // Info.plist 파일의 설정을 지정합니다
            sources: factory.sources,                        // 소스 코드 파일들의 위치를 지정합니다
            resources: factory.resources,                    // 리소스 파일들(이미지, 폰트 등)의 위치를 지정합니다
            copyFiles: factory.copyFiles,                    // 빌드 시 복사할 파일들을 지정합니다
            headers: factory.headers,                           // 헤더 파일들의 설정을 지정합니다
            entitlements: factory.entitlements,                 // 앱의 권한 설정을 지정합니다
            scripts: factory.scripts,                           // 빌드 시 실행할 스크립트들을 지정합니다
            dependencies: factory.dependencies,                  // 타겟이 의존하는 다른 모듈들을 지정합니다
            settings: factory.settings,                         // 빌드 설정을 지정합니다
            coreDataModels: factory.coreDataModels,             // CoreData 모델 파일들을 지정합니다
            environmentVariables: factory.environmentVariables,           // 환경 변수들을 지정합니다
            launchArguments: factory.launchArguments,           // 실행 시 전달할 인자들을 지정합니다
            additionalFiles: factory.additionalFiles,           // 추가 파일들을 지정합니다
            buildRules: factory.buildRules,                     // 빌드 규칙들을 지정합니다
            mergedBinaryType: factory.mergedBinaryType,         // 바이너리 병합 유형을 지정합니다
            mergeable: factory.mergeable,                        // 다른 타겟과의 병합 가능 여부를 지정합니다
            onDemandResourcesTags: factory.onDemandResourcesTags // 주문형 리소스 태그들을 지정합니다
        )
    }
}

// MARK: -- Target + App
public extension Target {
    static func app(
        implements module: ModulePath.App,
        deploymentTarget: ProjectDeploymentTarget,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.App.name + module.rawValue
        
        let name: String = deploymentTarget == .debug ? Project.Environment.appName + "-\(deploymentTarget.rawValue)" : Project.Environment.appName
        
        let bundleId: String = if deploymentTarget == .debug {
            "\(Project.Environment.bundlePrefix).\(deploymentTarget.rawValue)"
        } else {
            Project.Environment.bundlePrefix
        }
        
        switch module {
        case .iOS:
            newFactory.product = .app
            newFactory.name = name
            newFactory.bundleId = bundleId
            newFactory.resources = ["Resources/**"]
            newFactory.productName = Project.Environment.appName
            newFactory.sources = .sources
            newFactory.entitlements = "\(Project.Environment.appName).entitlements"
            newFactory.dependencies = factory.dependencies
        case .NotificationExtension:
            newFactory.product = .appExtension
            newFactory.name = "\(Project.Environment.appName)-\(deploymentTarget.rawValue)-NotificationExtension"
            newFactory.bundleId = "\(bundleId).notification"
            newFactory.resources = ["Resources/**"]
            newFactory.sources = .notificationExtensionSources
        }

        return .make(factory: newFactory)
    }
    
    static func app(tests module: ModulePath.App, factory: TargetFactory) -> Self {
        let deploymentTarget = ProjectDeploymentTarget.debug
        var newFactory = factory
        newFactory.name = ModulePath.App.name + module.rawValue + "Tests"
        newFactory.product = .unitTests
        
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
        }
        
        return .make(factory: newFactory)
    }
}

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
        newFactory.sources = .sources

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

        return make(factory: newFactory)
    }
}

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

    static func core(example module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Example"
        newFactory.sources = .exampleSources
        newFactory.product = .app
        newFactory.bundleId = Project.Environment.bundlePrefix + ".\(module.rawValue)"

        return make(factory: newFactory)
    }
}

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

}
