//
//  ZipDownloadItem.swift
//  BoxSDK-iOS
//
//  Created by Skye Free on 1/12/21.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Item field for creating a Zip download.
public struct ZipDownloadItem: BoxInnerModel {

    // MARK: - Properties

    /// Identfier
    public let id: String
    /// Box item type - should be file or folder.
    public let type: String

    /// Initializer.
    ///
    /// - Parameters:
    ///   - id: Identfier
    ///   - type: Box item type - should be file or folder
    public init(
        id: String,
        type: String
    ) {
        self.id = id
        self.type = type
    }
}
