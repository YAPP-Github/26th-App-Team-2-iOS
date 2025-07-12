import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .shared(
        implements: .DesignSystem,
        factory: .init(
            dependencies: [
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
    
