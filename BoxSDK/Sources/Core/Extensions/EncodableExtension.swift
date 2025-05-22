//
//  EncodableExtension.swift
//  BoxSDK
//
//  Created by Daniel Cech on 10/04/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

public extension Encodable {

    /// Returns the dictionary object as a JSON represenation of current Encodable object, where keyEncodingStrategy was set to`convertToSnakeCase`
    var bodyDict: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: requestBodyEncoder.encode(self))) as? [String: Any] ?? [:]
    }

    /// Returns the dictionary object as a JSON represenation of current Encodable object, where keyEncodingStrategy was set to`useDefaultKeys`
    var bodyDictWithDefaultKeys: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: requestBodyEncoderWithDefaultKeys.encode(self))) as? [String: Any] ?? [:]
    }
}
