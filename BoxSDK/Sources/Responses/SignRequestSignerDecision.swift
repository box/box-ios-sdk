//
//  SignRequestSignerDecision.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 12/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Type of decision made by the signer
public enum SignRequestSignerDecisionType: BoxEnum {
    /// Signed decision.
    case signed
    /// Declined decision.
    case declined
    /// A custom value not implemented in this version of SDK.
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "signed":
            self = .signed
        case "declined":
            self = .declined
        default:
            self = .customValue(value)
        }
    }

    public var description: String {

        switch self {
        case .signed:
            return "signed"
        case .declined:
            return "declined"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Final decision made by the signer
public class SignRequestSignerDecision: BoxModel {

    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Type of decision made by the signer
    public let type: SignRequestSignerDecisionType?
    /// Date and Time that the decision was made
    public let finalizedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        type = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "type")
        finalizedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "finalized_at")
    }
}
