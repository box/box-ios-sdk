//
//  OHTTPStubs+JSONComparer.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/28/19.
//  Copyright © 2019 Box. All rights reserved.
//
import Foundation
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

public extension QuickSpec {

    /// Compare JSONBody
    /// We need it to create this method as the build in method hasJSONBody() from HTTPStubs doesn't work as
    /// expected, hasJSONBody expects that the jsonObject you pass in have the same keys and values in the same order
    /// and it's doesn't fullfill our needs as the serialization of the request can produce multiples results
    /// for example hasJSONBody() will fail if you compare {"id": "1234", "name": "sean" } vs {"name": "sean", "id": "1234"}
    /// - Parameter jsonObject: The JSON object we want to compare with the response of the stub api call
    /// - Returns: Return a HTTPStubsTestBlock.
    static func compareJSONBody(_ jsonObject: [String: Any], checkClosure: CheckClosureType? = nil) -> HTTPStubsTestBlock {
        return { req in
            guard
                let httpBody = req.ohhttpStubs_httpBody,
                let bodyString = String(data: httpBody, encoding: .utf8),
                let jsonObjectData = try? JSONSerialization.data(withJSONObject: jsonObject),
                let jsonObjectString = String(data: jsonObjectData, encoding: .utf8)
            else {
                return false
            }

            let match = JSONComparer.match(json1String: bodyString, json2String: jsonObjectString, checkClosure: checkClosure)
            return match
        }
    }

    static func compareURLEncodedBody(_ parameters: [String: String], checkClosure: CheckClosureType? = nil) -> HTTPStubsTestBlock {
        return { req in
            guard
                let httpBody = req.ohhttpStubs_httpBody,
                let bodyString = String(data: httpBody, encoding: .utf8)
            else {
                return false
            }

            let bodyParamList = bodyString.split(separator: "&").map { $0.removingPercentEncoding }.compactMap { $0?.split(separator: "=").prefix(2) }
            let bodyParamTupleList = bodyParamList.compactMap { paramPair -> (String, String)? in
                if paramPair.count == 2 {
                    return (String(paramPair[0]), String(paramPair[1]))
                }
                else {
                    return nil
                }
            }

            let bodyParamDict = Dictionary(uniqueKeysWithValues: bodyParamTupleList)
            let match = JSONComparer.match(json1: parameters, json2: bodyParamDict, checkClosure: checkClosure) // match(json1: parameters as Any, json2: bodyParamDict as Any)
            return match
        }
    }

    static func compareComplexQueryParam(_ key: String, _ partValues: [String], checkClosure _: CheckClosureType? = nil) -> HTTPStubsTestBlock {
        return { req in
            if let url = req.url {
                let comps = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
                guard let queryItems = comps?.queryItems else {
                    return false
                }

                guard let item = queryItems.first(where: { $0.name == key }) else {
                    return false
                }

                guard let value = item.value else {
                    return false
                }

                return partValues.allSatisfy { value.contains($0) }
            }

            return false
        }
    }
}
