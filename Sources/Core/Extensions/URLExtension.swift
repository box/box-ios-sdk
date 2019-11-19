//
//  URLExtension.swift
//  BoxSDK
//
//  Created by Daniel Cech on 30/04/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

extension URL {

    static func boxAPIEndpoint(_ endpoint: String, configuration: BoxSDKConfiguration) -> URL {
        return URL.make(from: endpoint, relativeTo: configuration.apiBaseURL)
    }

    static func boxUploadEndpoint(_ endpoint: String, configuration: BoxSDKConfiguration) -> URL {
        return URL.make(from: endpoint, relativeTo: configuration.uploadApiBaseURL)
    }

    private static func make(from string: String, relativeTo baseURL: URL) -> URL {
        guard let url = URL(string: string, relativeTo: baseURL) else {
            fatalError("Could not create URL from \(string.isEmpty ? "empty string" : string) relative to base URL: \(baseURL)")
        }
        return url
    }
}
