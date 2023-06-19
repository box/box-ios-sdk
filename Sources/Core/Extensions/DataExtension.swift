//
//  DataExtension.swift
//  BoxSDK
//
//  Created by Daniel Cech on 19/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import CommonCrypto
import CryptoKit
import Foundation

extension Data {
    private func sha1data() -> Data {
        if #available(macOS 10.15, iOS 13, *) {
            var hasher = Insecure.SHA1()
            hasher.update(data: self)
            let digest = hasher.finalize()
            return Data(digest)
        }

        var digest = Data(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        withUnsafeBytes { data in
            digest.withUnsafeMutableBytes { (rawbuffer: UnsafeMutableRawBufferPointer) in
                rawbuffer.withMemoryRebound(to: UInt8.self) { buffer in
                    _ = CC_SHA1(data.baseAddress, CC_LONG(self.count), buffer.baseAddress)
                }
            }
        }
        return digest
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
