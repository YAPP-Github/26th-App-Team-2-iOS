import ProjectDescription

private let layerAttribute = Template.Attribute.required("layer")
private let nameAttribute = Template.Attribute.required("name")
private let targetAttribute = Template.Attribute.required("target")
private let authorAttribute = Template.Attribute.required("author")
private let dateAttribute = Template.Attribute.required("date")

private let template = Template(
    description: "A template for a new module",
    attributes: [
        layerAttribute,
        nameAttribute,
        targetAttribute,
        authorAttribute,
        dateAttribute
    ],
    items: [
        .file(
            path: "Projects/\(layerAttribute)/\(nameAttribute)/Sources/Source.swift",
            templatePath: "Sources.stencil"
        ),
        .file(
            path: "Projects/\(layerAttribute)/\(nameAttribute)/Project.swift",
            templatePath: "Project.stencil"
        )
    ]
)
