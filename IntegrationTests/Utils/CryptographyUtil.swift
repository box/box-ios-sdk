//
//  CryptographyUtil.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 16/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

import CommonCrypto
import Foundation

class CryptographyUtil {
    static func sha1(for data: Data) -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }

        return Data(digest)
    }
}
