//
//  ZipDownloadConflict.swift
//  BoxSDK-iOS
//
//  Created by Skye Free on 1/19/21.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Defines a Zip Download Conflict
public class ZipDownloadConflict: BoxModel {
    // MARK: - Properties

    public private(set) var rawData: [String: Any]

    /// Conflict that occurs between items that have the same name.
    public let conflict: [ZipDownloadConflictItem]?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        conflict = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "conflict")
    }
}
