//
//  ZipDownloadStatus.swift
//  BoxSDK-iOS
//
//  Created by Skye Free on 1/12/21.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Status of a Zip download
public class ZipDownloadStatus: BoxModel {
    // MARK: - Properties

    public private(set) var rawData: [String: Any]

    /// The total number of files in the zip
    public let totalFileCount: Int
    /// The number of files in the zip that were downloaded
    public let downloadedFileCount: Int
    /// The number of files that were skipped when downloading
    public let skippedFileCount: Int
    /// The number of folders that were skipped when downloading
    public let skippedFolderCount: Int
    /// State of the download for the zip file
    public let state: String
    /// Conflicts that occur between items that have the same name. This is always initially nil and updated manually later, via the FilesModule.getZipDownloadStatus() method.
    public var nameConflicts: [ZipDownloadConflict]?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        totalFileCount = try BoxJSONDecoder.decode(json: json, forKey: "total_file_count")
        downloadedFileCount = try BoxJSONDecoder.decode(json: json, forKey: "downloaded_file_count")
        skippedFileCount = try BoxJSONDecoder.decode(json: json, forKey: "skipped_file_count")
        skippedFolderCount = try BoxJSONDecoder.decode(json: json, forKey: "skipped_folder_count")
        state = try BoxJSONDecoder.decode(json: json, forKey: "state")
        nameConflicts = nil
    }
}
