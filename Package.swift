// swift-tools-version:4.2
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
