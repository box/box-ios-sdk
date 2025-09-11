//
//  DataExtension.swift
//  BoxSDK
//
//  Created by Daniel Cech on 19/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

extension Data {
    private func sha1data() -> Data {
        let sha1 = SHA1()
        sha1.update(data: self)
        return sha1.finalize()
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
