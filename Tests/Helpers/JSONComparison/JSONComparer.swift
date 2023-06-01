//
//  JSONComparer.swift
//  BoxSDKTests-iOS
//
//  Created by Daniel Cech on 28/05/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

public enum CheckResult {
    case `default`
    case equal
    case nonEqual
}

public enum JSONPathElement {
    case string(String)
    case index(Int)
}

public typealias CheckClosureTuple = (first: Any, second: Any, path: [JSONPathElement])
public typealias CheckClosureType = (CheckClosureTuple) -> CheckResult

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

    class func match(json1Data: Data, json2Data: Data, checkClosure: CheckClosureType? = nil) -> Bool {
        guard
            let json1 = try? JSONSerialization.jsonObject(with: json1Data, options: []),
            let json2 = try? JSONSerialization.jsonObject(with: json2Data, options: [])
        else {
            return false
        }

        return JSONComparer.match(json1: json1, json2: json2, checkClosure: checkClosure)
    }

    class func match(json1: Any, json2: Any, path: [JSONPathElement] = [], checkClosure: CheckClosureType? = nil) -> Bool {

        if let checkResult = checkClosure?((first: json1, second: json2, path: path)) {
            switch checkResult {
            case .default:
                break
            case .equal:
                return true
            case .nonEqual:
                return reportMatch(false, path: path)
            }
        }

        switch (json1, json2) {

        case (_, _) as (NSNull, NSNull):
            return true

        case let (integer1, integer2) as (Int, Int):
            return reportMatch(integer1 == integer2, path: path)

        case let (bool1, bool2) as (Bool, Bool):
            return reportMatch(bool1 == bool2, path: path)

        case let (string1, string2) as (String, String):
            return reportMatch(string1 == string2, path: path)

        case let (array1, array2) as ([Any], [Any]):
            if array1.count != array2.count {
                return reportMatch(false, path: path)
            }

            for index in 0 ..< array1.count {
                let result = JSONComparer.match(
                    json1: array1[index],
                    json2: array2[index],
                    path: path + [.index(index)],
                    checkClosure: checkClosure
                )

                if !result {
                    return reportMatch(false, path: path)
                }
            }

            return true

        case let (dict1, dict2) as ([String: Any], [String: Any]):
            let dict1KeysSorted = dict1.keys.sorted()
            let dict2KeysSorted = dict2.keys.sorted()
            if dict1KeysSorted != dict2KeysSorted {
                return reportMatch(false, path: path)
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
                    return reportMatch(false, path: path)
                }
            }

            return true

        default:
            return reportMatch(false, path: path)
        }
    }

    class func reportMatch(_ match: Bool, path: [JSONPathElement]) -> Bool {
        if !match {
            print("JSONComparer: no match at \(path)")
        }

        return match
    }
}
