//
//  PollingURLInfo.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 01/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Polling URL info for requesting changes in event stream.
public class PollingURLInfo: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// URL value for checking for new events.
    public let url: URL
    /// Timeout in seconds after which request for new changes should be repeated.
    public let timeoutInSeconds: Int
    /// Maximum number of retries in case of failed request for new changes.
    public let maxRetries: String

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        guard let entries = json["entries"] as? [[String: Any]],
            let firstEntryJSON = entries.first else {
            throw BoxCodingError(message: .typeMismatch(key: "entries"))
        }

        url = try BoxJSONDecoder.decodeURL(json: firstEntryJSON, forKey: "url")
        timeoutInSeconds = try BoxJSONDecoder.decode(json: firstEntryJSON, forKey: "retry_timeout")
        maxRetries = try BoxJSONDecoder.decode(json: firstEntryJSON, forKey: "max_retries")
    }
}
