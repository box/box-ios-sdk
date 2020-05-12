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
        // This check is there to only run sanitization when string is path and not a full custom URL. Full URLs are just returned
        if URL(string: string)?.scheme == nil {
            let validParams = ["2.0", "thumbnail.jpg", "thumbnail.png"]
            var sanitizedURL = string
            validParams.forEach { param in
                sanitizedURL = sanitizedURL.replacingOccurrences(of: param, with: "")
            }
            let range = NSRange(location: 0, length: sanitizedURL.utf16.count)
            // Checks that url paths with relative paths like /../ or other invalid path parameters are not sent to the API
            let regex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9!@#$%^&*()_+\\/-]*$")
            if regex?.firstMatch(in: sanitizedURL, options: [], range: range) == nil {
                fatalError("An invalid path parameter exists in \(string). All parameters must be alphanumeric.")
            }
        }
        guard let url = URL(string: string, relativeTo: baseURL) else {
            fatalError("Could not create URL from \(string.isEmpty ? "empty string" : string) relative to base URL: \(baseURL)")
        }
        return url
    }
}
