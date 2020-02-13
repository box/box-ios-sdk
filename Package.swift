// swift-tools-version:5.0
//
//  BoxSDK.swift
//  BoxSDK
//
//  Created by Abel Osorio on 03/12/19.
//  Copyright © 2018 Box Inc. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "BoxSDK",
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
            path: "Sources"
        ),
        .testTarget(
            name: "BoxSDKTests",
            dependencies: ["BoxSDK"],
            path: "Tests"
        )
    ]
)
