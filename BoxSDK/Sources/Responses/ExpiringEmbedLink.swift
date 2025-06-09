//
//  ExpiringEmbedLink.swift
//  BoxSDK
//
//  Created by Abel Osorio on 3/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Expiring embed link of a file
public class ExpiringEmbedLink: BoxModel {
    // MARK: - Properties

    public private(set) var rawData: [String: Any]

    /// Embed link URL
    public let url: URL?
    /// Information about the token used by the embed component
    public let token: Token?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        url = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "url")
        token = try BoxJSONDecoder.optionalDecode(json: json, forKey: "token")
    }
}
