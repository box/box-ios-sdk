//
//  BoxResponse.swift
//  BoxSDK
//
//  Created by Daniel Cech on 02/04/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Box API request response
public struct BoxResponse {
    var request: BoxRequest
    var body: Data?
    var urlResponse: HTTPURLResponse?

    init(request: BoxRequest, body: Data?, urlResponse: URLResponse?) {
        self.request = request
        self.body = body
        self.urlResponse = urlResponse as? HTTPURLResponse
    }
}

typealias ResponseResult = (success: Bool, error: BoxSDKError?)
