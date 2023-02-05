// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ethereum",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Ethereum",
            targets: ["Ethereum"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.3.0"),
        .package(
            url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.6.0")),
        .package(url: "https://github.com/GigaBitcoin/secp256k1.swift.git", .upToNextMajor(from: "0.10.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Ethereum",
            dependencies: [
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "secp256k1", package: "secp256k1.swift"),
            ]
        ),
        .testTarget(
            name: "EthereumTests",
            dependencies: ["Ethereum"]
        ),
    ]
)
