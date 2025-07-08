//
//  Project+Templates.swift
//  Packages
//
//  Created by Greem on 6/19/25.
//

import ProjectDescription
import DependencyPlugin

public extension Project {
    static func makeModule(
        name: String,
        organizationName: String? = nil,
        options: Project.Options = .options(automaticSchemesOptions: .disabled),
        packages: [Package] = [],
        settings: Settings? = Project.Environment.projectSettings,
        targets: [Target],
        schemes: [Scheme] = [],
        fileHeaderTemplate: FileHeaderTemplate? = nil,
        additionalFiles: [FileElement] = [],
        resourceSynthesizers: [ResourceSynthesizer] = []
    ) -> Self {
        return .init(
            name: name,
            organizationName: organizationName,
            options: options,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes,
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}
