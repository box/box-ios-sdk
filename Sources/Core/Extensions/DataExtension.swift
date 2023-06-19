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
    private func sha1data() -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(self.count), &digest)
        }
        return Data(digest)
    }

    func sha1() -> String {
        let digest = sha1data()
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }

    func sha1Base64Encoded() -> String {
        let digest = sha1data()
        let base64String = digest.base64EncodedString(options: [])
        return base64String
    }
}
