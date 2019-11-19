//
//  EncodableExtension.swift
//  BoxSDK
//
//  Created by Daniel Cech on 10/04/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

extension Encodable {
    var bodyDict: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: requestBodyEncoder.encode(self))) as? [String: Any] ?? [:]
    }

    var bodyDictWithDefaultKeys: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: requestBodyEncoderWithDefaultKeys.encode(self))) as? [String: Any] ?? [:]
    }
}
