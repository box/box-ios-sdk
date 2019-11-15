//
//  BoxRequestDescription.swift
//  BoxSDK
//
//  Created by Daniel Cech on 10/05/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// The components that make up a URL
public struct BoxURLComponents {
    /// URL scheme information
    public var scheme: String?
    /// URL host information
    public var host: String?
    /// URL path
    public var path: String?
    /// Optional URL query parameters
    public var query: [String: String]?
    /// Optional page reference / anchor
    public var fragment: String?

    init(fromURL url: URL) {
        let components = URLComponents(url: url.absoluteURL, resolvingAgainstBaseURL: false)
        scheme = components?.scheme
        host = components?.host
        path = components?.path

        var queryItemsDict = [String: String]()
        if let queryItems = components?.queryItems {
            queryItemsDict = Dictionary(uniqueKeysWithValues: queryItems.compactMap { item in
                if let value = item.value {
                    return (item.name, value)
                }
                else {
                    return nil
                }
            })
        }

        query = queryItemsDict
        fragment = components?.fragment
    }

    func getDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["scheme"] = scheme
        dict["host"] = host
        dict["path"] = path
        dict["query"] = query
        dict["fragment"] = fragment
        return dict
    }
}

/// The components that make up a description of a BoxRequest
public struct BoxRequestDescription {
    /// The HTTP method for the BoxRequest
    public var method: String
    /// The URL the BoxRequest is sent to
    public var url: BoxURLComponents
    /// The HTTP headers sent in the BoxRequest
    public var headers: BoxHTTPHeaders
    /// The optional body of the BoxRequest
    public var body: String?

    init(fromRequest request: BoxRequest) {
        method = request.httpMethod.rawValue.uppercased()
        url = BoxURLComponents(fromURL: request.url)
        headers = request.httpHeaders

        if let unwrappedBody = request.bodyDescription {
            body = String(data: unwrappedBody, encoding: .utf8)
        }
    }

    func getDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["method"] = method
        dict["url"] = url.getDictionary()
        dict["headers"] = headers
        // swiftlint:disable:next force_https
        dict["body"] = body
        return dict
    }
}
