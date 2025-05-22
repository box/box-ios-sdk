//
//  ZipDownloadConflictItem.swift
//  BoxSDK-iOS
//
//  Created by Skye Free on 1/19/21.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Defines a Zip Download Conflict Item
public class ZipDownloadConflictItem: BoxModel {

    // MARK: - Properties

    public private(set) var rawData: [String: Any]

    /// Identfier
    public let id: String
    /// Box item type - file or folder.
    public let type: String
    /// The original name of the item that has the conflict
    public let originalName: String
    /// The new name of the item when it downloads that resolves the conflict
    public let downloadName: String

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        type = try BoxJSONDecoder.decode(json: json, forKey: "type")
        originalName = try BoxJSONDecoder.decode(json: json, forKey: "original_name")
        downloadName = try BoxJSONDecoder.decode(json: json, forKey: "download_name")
    }
}
