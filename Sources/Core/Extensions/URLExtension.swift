//
//  URLExtension.swift
//  BoxSDK
//
//  Created by Daniel Cech on 30/04/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

public extension URL {

    /// Creates a valid `URL` based on configuration's `apiBaseURL` and `endpoint` path
    ///
    /// - Parameters:
    ///   - endpoint: The relative path that will be appended to `apiBaseURL`
    ///   - configuration: The SDK configuration that provides `apiBaseURL` URL
    /// - Returns: The URL of the API endpoint.
    static func boxAPIEndpoint(_ endpoint: String, configuration: BoxSDKConfiguration) -> URL {
        return URL.make(from: endpoint, relativeTo: configuration.apiBaseURL)
    }

    /// Creates a valid `URL` based on configuration's `uploadApiBaseURL` and `endpoint` path
    ///
    /// - Parameters:
    ///   - endpoint: The relative path that will be appended to `uploadApiBaseURL`
    ///   - configuration: The SDK configuration that provides `uploadApiBaseURL` URL
    /// - Returns: The URL of the upload API endpoint.
    static func boxUploadEndpoint(_ endpoint: String, configuration: BoxSDKConfiguration) -> URL {
        return URL.make(from: endpoint, relativeTo: configuration.uploadApiBaseURL)
    }

    private static func make(from string: String, relativeTo baseURL: URL) -> URL {
        // Checks that url paths with relative paths like /.. are not sent to the API
        let pattern = "\\/\\.+"
        if string.range(of: pattern, options: .regularExpression) != nil {
            fatalError("An invalid path parameter exists in \(string). Relative path parameters cannot be passed.")
        }
        guard let url = URL(string: string, relativeTo: baseURL) else {
            fatalError("Could not create URL from \(string.isEmpty ? "empty string" : string) relative to base URL: \(baseURL)")
        }
        return url
    }
}
