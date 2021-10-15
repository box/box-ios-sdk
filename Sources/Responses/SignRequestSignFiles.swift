//
//  SignRequestSignFiles.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 12/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// List of files that will be signed, which are copies of the original source files.
/// A new version of these files are created as signers sign and can be downloaded at any point in the signing process.
public class SignRequestSignFiles: BoxModel {

    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Files that signing events will occur on - these are copies of the original source files.
    public let files: [File]?
    /// Indicates whether the `signFiles` documents are processing and the PDFs may be out of date.
    /// A change to any document requires processing on all `signFiles`.
    /// We recommended waiting until processing is finished (and this value is true) before downloading the PDFs.
    public let isReadyForDownload: Bool?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        files = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "files")
        isReadyForDownload = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_ready_for_download")
    }
}
