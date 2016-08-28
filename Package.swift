import PackageDescription

let package = Package(
    name: "SwiftGumbo",
    dependencies: [
        .Package(url: "https://github.com/takebayashi/CGumbo.git", majorVersion: 0),
    ]
)
