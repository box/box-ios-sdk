//
//  Token.swift
//  BoxSDK
//
//  Created by Abel Osorio on 3/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Embed link token
public class Token: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Access token.
    public let accessToken: String?
    /// Expiration time interval since
    public let expiresIn: Int?
    /// Type of token
    public let tokenType: String?
    /// Token permissions
    public let restrictedTo: [Scope]?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        accessToken = try BoxJSONDecoder.optionalDecode(json: json, forKey: "access_token")
        expiresIn = try BoxJSONDecoder.optionalDecode(json: json, forKey: "expires_in")
        tokenType = try BoxJSONDecoder.optionalDecode(json: json, forKey: "token_type")
        restrictedTo = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "scope")
    }
}
