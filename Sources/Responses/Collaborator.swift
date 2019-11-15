//
//  Collaborator.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer on 6/18/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// User taking part in a collaboration.
public class Collaborator: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    public enum CollaboratorType {
        case user(User)
        case group(Group)
    }

    public var collaboratorValue: CollaboratorType

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        guard let type = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }
        switch type {
        case "user":
            let user = try User(json: json)
            collaboratorValue = .user(user)
        case "group":
            let group = try Group(json: json)
            collaboratorValue = .group(group)
        default:
            throw BoxCodingError(message: .valueMismatch(key: "type", value: type, acceptedValues: ["user", "group"]))
        }
    }
}
