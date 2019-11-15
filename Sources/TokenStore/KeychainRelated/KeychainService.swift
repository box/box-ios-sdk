//
//  KeychainService.swift
//  BoxSDK
//
//  Created by Abel Osorio on 4/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation
import Security

struct KeychainService {
    let secureStoreQueryable: KeychainStoreQueryable

    init(secureStoreQueryable: KeychainStoreQueryable) {
        self.secureStoreQueryable = secureStoreQueryable
    }

    func set<T: Encodable>(_ value: T?, key: String) throws {
        guard let json = value?.dictionary,
            let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions()) else {
            throw BoxSDKError(message: .keychainDataConversionError)
        }

        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = key

        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = data

            status = SecItemUpdate(
                query as CFDictionary,
                attributesToUpdate as CFDictionary
            )
            if status != errSecSuccess {
                throw error(from: status)
            }
        case errSecItemNotFound:
            query[String(kSecValueData)] = data

            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }

    func getValue<T: Decodable>(_ key: String) throws -> T? {
        var query = secureStoreQueryable.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = key

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let valueData = queriedItem[String(kSecValueData)] as? Data,
                let value = try? JSONDecoder().decode(T.self, from: valueData)
            else {
                throw BoxSDKError(message: .keychainDataConversionError)
            }
            return value
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }

    func removeValue(for key: String) throws {
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = key

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    func removeAllValues() throws {
        let query = secureStoreQueryable.query

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    func error(from status: OSStatus) -> BoxSDKError {
        if #available(iOS 11.3, *, watchOSApplicationExtension 4.3, *, tvOS 11.3, *) {
            let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")

            return BoxSDKError(message: .keychainUnhandledError(message))
        }
        else {
            // Fallback on earlier versions
            return BoxSDKError(message: .keychainUnhandledError(""))
        }
    }
}

private extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
