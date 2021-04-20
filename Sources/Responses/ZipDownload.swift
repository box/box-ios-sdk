//
//  ZipDownload.swift
//  BoxSDK-iOS
//
//  Created by Skye Free on 1/11/21.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Defines a Zip Download
public class ZipDownload: BoxModel {
    // MARK: - Properties

    public private(set) var rawData: [String: Any]

    /// The URL to download the Zip file. If entered in a browser, this URL will trigger a download of the Zip file.
    public let downloadUrl: URL
    /// The URL to monitor the status of the download.
    public let statusUrl: URL
    /// Expiration date of the Zip file download.
    public let expiresAt: Date?
    /// Conflicts that occur between items that have the same name.
    public let nameConflicts: [ZipDownloadConflict]?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        downloadUrl = try BoxJSONDecoder.decodeURL(json: json, forKey: "download_url")
        statusUrl = try BoxJSONDecoder.decodeURL(json: json, forKey: "status_url")
        expiresAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "expires_at")
        nameConflicts = try BoxJSONDecoder.optionalDecodeZipCollection(json: json, forKey: "name_conflicts")
    }
}
