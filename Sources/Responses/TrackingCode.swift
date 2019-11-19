//
//  TrackingCode.swift
//  BoxSDK
//
//  Created by Abel Osorio on 3/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Admin-defined information about a user
public class TrackingCode: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Tracking code key.
    public let name: String
    /// Tracking code value.
    public let value: String

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        name = try BoxJSONDecoder.decode(json: json, forKey: "name")
        value = try BoxJSONDecoder.decode(json: json, forKey: "value")
    }
}
