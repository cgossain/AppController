// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "app-controller",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AppController",
            targets: ["AppController"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AppController",
            dependencies: []
        ),
        .testTarget(
            name: "AppControllerTests",
            dependencies: [
                "AppController"
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
