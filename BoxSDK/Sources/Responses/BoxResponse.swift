//
//  BoxResponse.swift
//  BoxSDK
//
//  Created by Daniel Cech on 02/04/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Box API response
public struct BoxResponse {
    /// The Box SDK API request related to this response.
    public let request: BoxRequest
    ///  The body of the response in a binary format
    public let body: Data?
    ///  The object that represents a  HTTP response which includes data such as
    /// `statusCode` or `allHeaderFields`
    public let urlResponse: HTTPURLResponse?

    init(request: BoxRequest, body: Data?, urlResponse: URLResponse?) {
        self.request = request
        self.body = body
        self.urlResponse = urlResponse as? HTTPURLResponse
    }
}

typealias ResponseResult = (success: Bool, error: BoxSDKError?)
