//
//  Config.swift
//  Packages
//
//  Created by Greem on 6/19/25.
//

import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToRoot("DependencyPlugin")),
    ]
)
