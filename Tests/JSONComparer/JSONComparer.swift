//
//  JSONComparer.swift
//  BoxSDKTests-iOS
//
//  Created by Daniel Cech on 28/05/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

enum CheckResult {
    case `default`
    case equal
    case nonEqual
}

enum JSONPathElement {
    case string(String)
    case index(Int)
}

typealias CheckClosureType = (_ expression1: Any, _ expression2: Any, _ path: [JSONPathElement]) -> CheckResult

class JSONComparer {

    class func match(json1String: String, json2String: String, checkClosure: CheckClosureType? = nil) -> Bool {
        guard
            let json1Data = json1String.data(using: .utf8),
            let json2Data = json2String.data(using: .utf8)
        else {
            return false
        }

        return JSONComparer.match(json1Data: json1Data, json2Data: json2Data, checkClosure: checkClosure)
    }

    class func match(json1Data: Data, json2Data: Data, checkClosure: CheckClosureType?) -> Bool {
        guard
            let json1 = try? JSONSerialization.jsonObject(with: json1Data, options: []),
            let json2 = try? JSONSerialization.jsonObject(with: json2Data, options: [])
        else {
            return false
        }

        return JSONComparer.match(json1: json1, json2: json2, checkClosure: checkClosure)
    }

    class func match(json1: Any, json2: Any, path: [JSONPathElement] = [], checkClosure: CheckClosureType?) -> Bool {

        if let checkResult = checkClosure?(json1, json2, path) {
            switch checkResult {
            case .default:
                break
            case .equal:
                return true
            case .nonEqual:
                return false
            }
        }

        switch (json1, json2) {

        case let (integer1, integer2) as (Int, Int):
            return integer1 == integer2

        case let (bool1, bool2) as (Bool, Bool):
            return bool1 == bool2

        case let (string1, string2) as (String, String):
            return string1 == string2

        case let (array1, array2) as ([Any], [Any]):
            if array1.count != array2.count {
                return false
            }

            for index in 0 ..< array1.count {
                let result = JSONComparer.match(
                    json1: array1[index],
                    json2: array2[index],
                    path: path + [.index(index)],
                    checkClosure: checkClosure
                )

                if !result {
                    return false
                }
            }

            return true

        case let (dict1, dict2) as ([String: Any], [String: Any]):
            let dict1KeysSorted = dict1.keys.sorted()
            let dict2KeysSorted = dict2.keys.sorted()
            if dict1KeysSorted != dict2KeysSorted {
                return false
            }

            for key in dict1KeysSorted {
                let result = JSONComparer.match(
                    // swiftlint:disable:next force_unwrap
                    json1: dict1[key]!,
                    // swiftlint:disable:next force_unwrap
                    json2: dict2[key]!,
                    path: path + [.string(key)],
                    checkClosure: checkClosure
                )

                if !result {
                    return false
                }
            }

            return true

        default:
            return false
        }
    }
}
