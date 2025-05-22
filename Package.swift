// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "BoxSDK",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "BoxSDK", targets: ["BoxSDK"]),
        .library(name: "BoxSdkGen", targets: ["BoxSdkGen"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BoxSDK",
            dependencies: [],
            path: "BoxSDK/Sources",
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ]
        ),
        .target(
            name: "BoxSdkGen",
            dependencies: [],
            path: "BoxSdkGen/Sources",
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ]
        ),
        .testTarget(
            name: "BoxSdkGenTests",
            dependencies: ["BoxSdkGen"],
            path: "BoxSdkGen/Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)