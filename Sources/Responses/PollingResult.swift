//
//  PollingResult.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 02/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// An events long polling result.
public class PollingResult: BoxModel {
    /// Box item type
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Version
    public let version: Int
    /// Message specifying type of the response.
    public let message: EventObserverResponse

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        version = try BoxJSONDecoder.decode(json: json, forKey: "version")
        message = try BoxJSONDecoder.decodeEnum(json: json, forKey: "message")
    }
}
