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

let project: Project = .init(
    name: "\(ModulePath.Shared.name)_\(ModulePath.Shared.DesignSystem.rawValue)",
    targets: targets,
    resourceSynthesizers: [
        .assets(),
        .fonts()
    ]
)
    
