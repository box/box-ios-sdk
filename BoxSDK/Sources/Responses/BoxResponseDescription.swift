//
//  BoxResponseDescription.swift
//  BoxSDK
//
//  Created by Daniel Cech on 10/05/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// The components that make up a description of a BoxResponse
public struct BoxResponseDescription {
    /// The HTTP status code of the response
    public var statusCode: Int?
    /// The HTTP headers of the response
    public var headers: BoxHTTPHeaders?
    /// The body component of the response
    public var body: [String: Any]?

    init(fromResponse response: BoxResponse) {
        statusCode = response.urlResponse?.statusCode
        headers = response.urlResponse?.allHeaderFields as? [String: String]

        if let unwrappedBody = response.body {
            body = try? JSONSerialization.jsonObject(with: unwrappedBody, options: []) as? [String: Any]
        }
    }

    func getDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["statusCode"] = statusCode
        dict["headers"] = headers
        dict["body"] = body
        return dict
    }
}
