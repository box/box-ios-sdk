//
//  URLValidation.swift
//  BoxSDK
//
//  Created by Martina Stremeňová on 8/21/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

enum URLValidation {
    static func validate(networkUrl: URL) throws {
        if networkUrl.scheme != "https" ||
            networkUrl.host == nil {
            throw BoxSDKError(message: .invalidURL(urlString: networkUrl.absoluteString))
        }
    }
}
