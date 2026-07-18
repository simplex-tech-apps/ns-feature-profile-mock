// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NSFeatureProfileMock",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "NSFeatureProfileMock",
            targets: ["NSFeatureProfileMock"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/simplex-tech-apps/ns-core-design-system.git",
            from: "1.2.0"
        )
    ],
    targets: [
        .target(
            name: "NSFeatureProfileMock",
            dependencies: [
                .product(name: "NammaAppUI", package: "ns-core-design-system")
            ]
        )
    ]
)
