// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BoxSdkGen",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "BoxSdkGen",
            targets: ["BoxSdkGen"]
        )
    ],
    targets: [
        .target(
            name: "BoxSdkGen",
            dependencies: [],
            path: "Sources",
            exclude: ["Info.plist"],
            resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "BoxSdkGenTests",
            dependencies: ["BoxSdkGen"],
            path: "Tests"
        )
    ]
)