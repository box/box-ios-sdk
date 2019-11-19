//
//  TokenInfo.swift
//  BoxSDK-iOS
//
//  Created by Daniel Cech on 25/03/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Info about the tokens used by the SDK for authentication.
public class TokenInfo: Codable {
    // MARK: - Properties

    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case expiresIn
        case tokenType
        case restrictedTo
        case expiresAt
        case issuedTokenType
    }

    var accessToken: String
    var refreshToken: String?
    var expiresIn: TimeInterval
    var tokenType: String
    private var restrictedTo: [[String: AnyCodable]]?
    let expiresAt: Date
    var issuedTokenType: String?

    var restrictedToObjects: [[String: Any]] {
        guard let unwrappedRestrictedTo = restrictedTo else {
            return []
        }

        return unwrappedRestrictedTo.map { item in
            item.mapValues { $0.value }
        }
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        expiresIn = try container.decode(Double.self, forKey: .expiresIn)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        restrictedTo = try container.decodeIfPresent([[String: AnyCodable]].self, forKey: .restrictedTo)

        if let decodedExpiresAt = try container.decodeIfPresent(Date.self, forKey: .expiresAt) {
            expiresAt = decodedExpiresAt
        }
        else {
            expiresAt = Date(timeInterval: expiresIn, since: Date())
        }

        issuedTokenType = try container.decodeIfPresent(String.self, forKey: .issuedTokenType)
    }

    /// Initializer
    ///
    /// - Parameters:
    ///   - accessToken: Access token.
    ///   - refreshToken: Refresh token.
    ///   - expiresIn: Expiration date of the token.
    ///   - tokenType: Type of the token.
    public init(accessToken: String, refreshToken: String?, expiresIn: TimeInterval, tokenType: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
        expiresAt = Date(timeInterval: expiresIn, since: Date())
    }

    /// Initializer.
    ///
    /// - Parameters:
    ///   - accessToken: Access token.
    ///   - expiresIn: Expiration date of the token.
    public init(accessToken: String, expiresIn: TimeInterval) {
        self.accessToken = accessToken
        refreshToken = nil
        self.expiresIn = expiresIn
        tokenType = "bearer"
        expiresAt = Date(timeInterval: expiresIn, since: Date())
    }
}

extension TokenInfo: Equatable {
    /// Compares tokens
    ///
    /// - Parameters:
    ///   - lhs: First token
    ///   - rhs: Second tken
    /// - Returns: True in case tokens are the same, false otherwise.
    public static func == (lhs: TokenInfo, rhs: TokenInfo) -> Bool {
        guard lhs.accessToken == rhs.accessToken,
            lhs.refreshToken == rhs.refreshToken else {
            return false
        }
        return true
    }
}
