import ProjectDescription

private let layerAttribute = Template.Attribute.required("layer")
private let nameAttribute = Template.Attribute.required("name")
private let authorAttribute = Template.Attribute.required("author")
private let dateAttribute = Template.Attribute.required("date")

private let template = Template(
    description: "A template for a new module's unit test target",
    attributes: [
        layerAttribute,
        nameAttribute,
        authorAttribute,
        dateAttribute
    ],
    items: [
        .file(
            path: "Projects/\(layerAttribute)/\(nameAttribute)/Testing/Sources/\(nameAttribute)Testing.swift",
            templatePath: "Testing.stencil"
        )
    ]
)
