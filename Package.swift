// swift-tools-version:5.7
//
//  BoxSDK.swift
//  BoxSDK
//
//  Created by Abel Osorio on 03/12/19.
//  Copyright © 2018 Box Inc. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "BoxSDKSuite",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "BoxSDK",
            targets: ["BoxSDK"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BoxSDK",
            dependencies: [],
            path: "BoxSDK/Sources",
            resources: [.copy("PrivacyInfo.xcprivacy")]
        )
    ],
    swiftLanguageVersions: [.v5]
)
