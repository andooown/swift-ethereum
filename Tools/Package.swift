// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Tools",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-format.git", branch: "release/5.7"),
        .package(url: "https://github.com/uber/mockolo.git", .upToNextMajor(from: "1.6.3")),
    ],
    targets: [
        .target(name: "Tools", path: "")
    ]
)
