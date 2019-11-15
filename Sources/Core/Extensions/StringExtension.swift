//
//  StringExtension.swift
//  BoxSDK
//
//  Created by Daniel Cech on 20/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

extension String {
    func dataFromHexString() -> Data {
        var hex = self
        var data = Data()
        while !hex.isEmpty {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let substring = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var characterInt: UInt32 = 0
            Scanner(string: substring).scanHexInt32(&characterInt)
            var character = UInt8(characterInt)
            data.append(&character, count: 1)
        }
        return data
    }
}
