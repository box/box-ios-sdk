//
//  DataExtension.swift
//  BoxSDK
//
//  Created by Daniel Cech on 19/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import CommonCrypto
import Foundation

extension Data {
    func sha1() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(self.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }

    func sha1Base64Encoded() -> String {
        let data = sha1().dataFromHexString()
        let base64String = data.base64EncodedString(options: [])
        return base64String
    }
}
