//
//  BoxSDKError.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 10/14/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

public enum BoxSDKErrorEnum: BoxEnum {
    // swiftlint:disable cyclomatic_complexity
    case clientDestroyed
    case invalidURL(urlString: String)
    case notFound(String)
    case instanceDeallocated(String)
    case keychainDataConversionError
    case keychainNoValue
    case keychainUnhandledError(String)
    case rateLimitMaxRetries
    case typeMismatch(key: String)
    case valueMismatch(key: String, value: String, acceptedValues: [String])
    case invalidValueFormat(key: String)
    case notPresent(key: String)
    case representationCreationFailed
    case tokenStoreFailure
    case tokenRetrieval
    case invalidOAuthRedirectConfiguration
    case invalidOAuthState
    case unauthorizedAccess
    case refreshTokenNotFound
    case expiredToken
    case jwtAuthError
    case nonIterableResponse
    case endOfList
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "clientDestroyed":
            self = .clientDestroyed
        case "keychainDataConversionError":
            self = .keychainDataConversionError
        case "keychainNoValue":
            self = .keychainNoValue
        case "rateLimitMaxRetries":
            self = .rateLimitMaxRetries
        case "representationCreationFailed":
            self = .representationCreationFailed
        case "tokenStoreFailure":
            self = .tokenStoreFailure
        case "tokenRetrieval":
            self = .tokenRetrieval
        case "invalidOAuthRedirectConfiguration":
            self = .invalidOAuthRedirectConfiguration
        case "invalidOAuthState":
            self = .invalidOAuthState
        case "unauthorizedAccess":
            self = .unauthorizedAccess
        case "refreshTokenNotFound":
            self = .refreshTokenNotFound
        case "expiredToken":
            self = .expiredToken
        case "jwtAuthError":
            self = .jwtAuthError
        case "nonIterableResponse":
            self = .nonIterableResponse
        case "endOfList":
            self = .endOfList
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .clientDestroyed:
            return "Tried to use a BoxClient instance that was already destroyed"
        case let .invalidURL(urlString):
            return "Invalid URL: \(urlString)"
        case let .notFound(message):
            return "Not found: \(message)"
        case let .instanceDeallocated(message):
            return "Object needed in closure was deallocated: \(message)"
        case .keychainDataConversionError:
            return "Could not decode or encode data for or from keychain"
        case .keychainNoValue:
            return "Value not found in Keychain"
        case let .keychainUnhandledError(message):
            return "Unhandled keychain error: \(message)"
        case .rateLimitMaxRetries:
            return "Request has hit the maximum number of retries"
        case let .typeMismatch(key):
            return "Value for key \(key) was of an unexpected type"
        case let .valueMismatch(key, value, acceptedValues):
            return "Value for key \(key) is \(value), which is not one of the accepted values [\(acceptedValues.map { "\(String(describing: $0))" }.joined(separator: ", "))]"
        case let .invalidValueFormat(key):
            return "Value for key \(key) is of a valid type, but was not able to convert value to expected type"
        case let .notPresent(key):
            return "Key \(key) was not present"
        case .representationCreationFailed:
            return "The file representation could not be made"
        case .tokenStoreFailure:
            return "Could not finish the operation (write, read or clear) on TokenStore object"
        case .tokenRetrieval:
            return "Unsuccessful token retrieval. Token was not found"
        case .invalidOAuthRedirectConfiguration:
            return "Failed OAuth web session authorization"
        case .invalidOAuthState:
            return "Couldn't obtain authorization code from OAuth web session success result"
        case .unauthorizedAccess:
            return "Unauthorized request to API"
        case .refreshTokenNotFound:
            return "Unsuccessful refresh token retrieval. Token was not found in the retrieved TokenInfo object"
        case .expiredToken:
            return "Access token has expired"
        case .jwtAuthError:
            return "Authorization with JWT token failed"
        case .nonIterableResponse:
            return "Cannot create paging iterable for non-paged response"
        case .endOfList:
            return "The end of the list has been reached"
        case let .customValue(userValue):
            return userValue
        }
    }

    // swiftlint:enable cyclomatic_complexity
}

extension BoxSDKErrorEnum: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = BoxSDKErrorEnum(value)
    }
}

/// Describes general SDK errors
public class BoxSDKError: Error {
    public var errorType: String
    public var message: BoxSDKErrorEnum
    public var stackTrace: [String]
    public var error: Error?

    init(message: BoxSDKErrorEnum = "Internal SDK Error", error: Error? = nil) {
        errorType = "BoxSDKError"
        self.message = message
        stackTrace = Thread.callStackSymbols
        self.error = error
    }

    public func getDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["errorType"] = errorType
        dict["message"] = message.description
        dict["stackTrace"] = stackTrace
        dict["error"] = error?.localizedDescription
        return dict
    }
}

extension BoxSDKError: CustomStringConvertible {
    /// Provides error JSON string if found.
    public var description: String {
        guard
            let encodedData = try? JSONSerialization.data(withJSONObject: getDictionary(), options: [.prettyPrinted, .sortedKeys]),
            let JSONString = String(data: encodedData, encoding: .utf8) else {
            return "<Unparsed Box Error>"
        }
        return JSONString.replacingOccurrences(of: "\\", with: "")
    }
}

extension BoxSDKError: LocalizedError {
    public var errorDescription: String? {
        return message.description
    }
}
