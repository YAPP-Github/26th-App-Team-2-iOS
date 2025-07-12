import ProjectDescription

private let layerAttribute = Template.Attribute.required("layer")
private let nameAttribute = Template.Attribute.required("name")
private let authorAttribute = Template.Attribute.required("author")
private let dateAttribute = Template.Attribute.required("date")

private let template = Template(
    description: "A template for a new module's interface target",
    attributes: [
        layerAttribute,
        nameAttribute,
        authorAttribute,
        dateAttribute
    ],
    items: [
        .file(
            path: "Projects/\(layerAttribute)/\(nameAttribute)/Interface/Sources/\(nameAttribute)Interface.swift",
            templatePath: "Interface.stencil"
        )
    ]
)
