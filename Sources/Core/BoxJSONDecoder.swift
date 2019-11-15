//
//  BoxJSONDecoder.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/28/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

// swiftlint:disable:next convenience_type
class BoxJSONDecoder {

    private static func extractJSON<T>(json: [String: Any], key: String) throws -> T {
        guard let objectJSON = json[key] else {
            throw BoxCodingError(message: .notPresent(key: key))
        }

        guard let object = objectJSON as? T else {
            throw BoxCodingError(message: .typeMismatch(key: key))
        }

        return object
    }

    private static func optionalExtractJSON<T>(json: [String: Any], key: String) throws -> T? {
        guard let objectJSON = json[key] else {
            return nil
        }

        if objectJSON is NSNull {
            return nil
        }

        guard let object = objectJSON as? T else {
            throw BoxCodingError(message: .typeMismatch(key: key))
        }

        return object
    }

    // MARK: - Optional decodes

    static func optionalDecode<T>(json: [String: Any], forKey key: String) throws -> T? where T: BoxModel {
        guard let modelJSON: [String: Any] = try optionalExtractJSON(json: json, key: key) else {
            return nil
        }

        return try decode(json: modelJSON)
    }

    static func optionalDecodeCollection<T>(json: [String: Any], forKey key: String) throws -> [T]? where T: BoxModel {
        guard let modelCollectionJSON: [[String: Any]] = try optionalExtractJSON(json: json, key: key) else {
            return nil
        }

        return try modelCollectionJSON.compactMap { try decode(json: $0) }
    }

    static func optionalDecodeCollection<T>(json: [String: Any], forKey key: String) throws -> [T]? where T: BoxInnerModel {
        guard let modelCollectionJSON: [[String: Any]] = try optionalExtractJSON(json: json, key: key) else {
            return nil
        }

        return try modelCollectionJSON.compactMap { try decode(json: $0) }
    }

    static func optionalDecodeEnumCollection<T>(json: [String: Any], forKey key: String) throws -> [T]? where T: BoxEnum {
        guard let stringCollection: [String] = try optionalExtractJSON(json: json, key: key) else {
            return nil
        }

        return stringCollection.map { T($0) }
    }

    static func optionalDecode<T>(json: [String: Any], forKey key: String) throws -> T? where T: BoxInnerModel {

        guard let modelJSON: [String: Any] = try optionalExtractJSON(json: json, key: key) else {
            return nil
        }

        return try decode(json: modelJSON)
    }

    static func optionalDecode<T>(json: [String: Any], forKey key: String) throws -> T? {

        guard let castedValue: T = try optionalExtractJSON(json: json, key: key) else {
            return nil
        }

        return castedValue
    }

    static func optionalDecodeRetentionLength(json: [String: Any]) throws -> Int? {
        let key = "retention_length"

        if let value = json[key] {
            if let intValue = value as? Int {
                return intValue
            }
            else if let stringValue = value as? String {
                if stringValue.elementsEqual("indefinite") {
                    return nil
                }
                else if let intValue = Int(stringValue) {
                    return intValue
                }
                throw BoxCodingError(message: .valueMismatch(key: key, value: stringValue, acceptedValues: ["indefinite", "Any Integer"]))
            }
            else if value is NSNull {
                return nil
            }
            else {
                throw BoxCodingError(message: .invalidValueFormat(key: key))
            }
        }
        else {
            return nil
        }
    }

    static func optionalDecodeDate(json: [String: Any], forKey key: String) throws -> Date? {
        guard let value: String = try optionalExtractJSON(json: json, key: key) else {
            return nil
        }

        guard let date = Date(fromISO8601String: value) else {
            throw BoxCodingError(message: .invalidValueFormat(key: key))
        }

        return date
    }

    static func optionalDecodeEnum<T>(json: [String: Any], forKey key: String) throws -> T? where T: BoxEnum {
        guard let value: String = try optionalExtractJSON(json: json, key: key) else {
            return nil
        }

        return T(value)
    }

    static func optionalDecodeURL(json: [String: Any], forKey key: String) throws -> URL? {
        guard let value: String = try optionalExtractJSON(json: json, key: key), !value.isEmpty else {
            return nil
        }

        guard let url = URL(string: value) else {
            throw BoxCodingError(message: .invalidValueFormat(key: key))
        }

        return url
    }

    // MARK: - Decodes

    static func decode<T>(json: [String: Any]) throws -> T where T: BoxModel {
        do {
            return try T(json: json)
        }
        catch let error as BoxSDKError {
            throw error
        }
        catch {
            throw BoxCodingError(error: error)
        }
    }

    static func decode<T>(json: [String: Any]) throws -> T where T: BoxInnerModel {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let object = try responseBodyDecoder.decode(T.self, from: data)
            return object
        }
        catch {
            throw BoxCodingError(error: error)
        }
    }

    static func decode<T>(json: [String: Any], forKey key: String) throws -> T {
        return try extractJSON(json: json, key: key)
    }

    static func decode<T>(json: [String: Any], forKey key: String) throws -> T where T: BoxInnerModel {
        let modelJSON: [String: Any] = try extractJSON(json: json, key: key)

        do {
            let data = try JSONSerialization.data(withJSONObject: modelJSON, options: [])
            return try responseBodyDecoder.decode(T.self, from: data)
        }
        catch {
            throw BoxCodingError(error: error)
        }
    }

    static func decode<T>(json: [String: Any], forKey key: String) throws -> T where T: BoxModel {
        let modelJSON: [String: Any] = try extractJSON(json: json, key: key)

        do {
            return try T(json: modelJSON)
        }
        catch let error as BoxSDKError {
            throw error
        }
        catch {
            throw BoxCodingError(error: error)
        }
    }

    static func decodeCollection<T>(json: [String: Any], forKey key: String) throws -> [T] where T: BoxModel {
        let objectCollectionJSON: [[String: Any]] = try extractJSON(json: json, key: key)

        return try objectCollectionJSON.compactMap { try BoxJSONDecoder.decode(json: $0) }
    }

    static func decodeDate(json: [String: Any], forKey key: String) throws -> Date {
        let value: String = try extractJSON(json: json, key: key)

        guard let date = Date(fromISO8601String: value) else {
            throw BoxCodingError(message: .invalidValueFormat(key: key))
        }

        return date
    }

    static func decodeEnum<T>(json: [String: Any], forKey key: String) throws -> T where T: BoxEnum {
        let value: String = try extractJSON(json: json, key: key)

        return T(value)
    }

    static func decodeURL(json: [String: Any], forKey key: String) throws -> URL {
        guard let url: URL = try optionalDecodeURL(json: json, forKey: key) else {
            throw BoxCodingError(message: .notPresent(key: key))
        }

        return url
    }
}
