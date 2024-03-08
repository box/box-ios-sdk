//
//  SignRequestSignatureColor.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 05/03/2024.
//  Copyright © 2024 box. All rights reserved.
//

import Foundation

/// Force a specific color for the signature
public enum SignRequestSignatureColor: BoxEnum {
    /// blue color
    case blue
    /// black color
    case black
    /// red color
    case red
    /// A custom value not implemented in this version of SDK.
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "blue":
            self = .blue
        case "black":
            self = .black
        case "red":
            self = .red
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .blue:
            return "blue"
        case .black:
            return "black"
        case .red:
            return "red"
        case let .customValue(userValue):
            return userValue
        }
    }
}
