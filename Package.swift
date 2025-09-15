// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "BoxSDKSuite",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "BoxSDK",
            targets: ["BoxSDKSuite"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BoxSDK",
            dependencies: [],
            path: "BoxSDK/Sources",
            resources: [.copy("PrivacyInfo.xcprivacy")]
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
        ),
        .target(
            name: "BoxSDKSuite",
            dependencies: ["BoxSdkGen", "BoxSDK"],
            path: "BoxSDKSuite/Sources"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
