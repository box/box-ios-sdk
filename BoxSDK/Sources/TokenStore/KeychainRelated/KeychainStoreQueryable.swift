//
//  KeychainStoreQueryable.swift
//  BoxSDK
//
//  Created by Abel Osorio on 4/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

protocol KeychainStoreQueryable {
    var query: [String: Any] { get }
}

struct GenericPasswordQueryable {
    let service: String
    let accessGroup: String?

    init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
}

extension GenericPasswordQueryable: KeychainStoreQueryable {
    var query: [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service
        // Access group if target environment is not simulator
        #if !targetEnvironment(simulator)
            if let accessGroup = accessGroup {
                query[String(kSecAttrAccessGroup)] = accessGroup
            }
        #endif
        return query
    }
}
