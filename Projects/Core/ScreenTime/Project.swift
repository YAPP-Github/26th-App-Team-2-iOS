import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name+ModulePath.Core.ScreenTime.rawValue,
    targets: [
        .core(
            interface: .ScreenTime,
            factory: .init(
                dependencies: [
                    .shared
                ]
            )
        ),
        .core(
            implements: .ScreenTime,
            factory: .init(
                dependencies: [
                    .core(interface: .ScreenTime)
                ]
            )
        ),

        .core(
            testing: .ScreenTime,
            factory: .init(
                dependencies: [
                    .core(interface: .ScreenTime)
                ]
            )
        ),
        .core(
            tests: .ScreenTime,
            factory: .init(
                dependencies: [
                    .core(testing: .ScreenTime)
                ]
            )
        )
    ]
)
