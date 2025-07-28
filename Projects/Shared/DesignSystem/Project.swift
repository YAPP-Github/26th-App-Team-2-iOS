import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .shared(
        implements: .DesignSystem,
        factory: .init()
    ),
    .shared(
        example: .DesignSystem,
        factory: .init(
            bundleId: "\(Project.Environment.bundlePrefix).design.system.example",
            infoPlist: Project.Environment.testAppInfoPlist(),
            dependencies: [
                .shared(implements: .DesignSystem),
            ]
        )
    )

]

let project: Project = .makeModule(
    name: ModulePath.Shared.name + ModulePath.Shared.DesignSystem.rawValue,
    targets: targets,
    resourceSynthesizers: [
        .assets(),
        .fonts()
    ]
)
    
