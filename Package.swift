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
            name: "BoxSDKGen",
            dependencies: [],
            path: "BoxSDKGen/Sources",
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ]
        ),
        .target(
            name: "BoxSDKSuite",
            dependencies: ["BoxSDKGen"],
            path: "BoxSDKSuite/Sources"
        ),
        .testTarget(
            name: "BoxSDKGenTests",
            dependencies: ["BoxSDKGen"],
            path: "BoxSDKGen/Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
