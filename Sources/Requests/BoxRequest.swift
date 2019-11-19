//
//  BoxRequest.swift
//  BoxSDK
//
//  Created by Daniel Cech on 02/04/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Represents Box SDK API request.
public class BoxRequest {

    /// Defines body type of a request
    public enum BodyType {
        /// JSON body type
        case jsonObject([String: Any])
        /// JSON Array body type
        case jsonArray([[String: Any]])
        /// URL encoded form body type
        case urlencodedForm([String: String])
        /// Data body type
        case data(Data)
        /// Multipart form body type
        case multipart(MultipartForm)
        /// Empty body
        case empty
    }

    var httpMethod: HTTPMethod
    var url: URL
    var httpHeaders: BoxHTTPHeaders
    var queryParams: QueryParameters
    var body: BodyType
    var progress: (Progress) -> Void

    // The path on the local FileSystem where a download request will write the data
    var downloadDestination: URL?

    init(
        httpMethod: HTTPMethod,
        url: URL,
        httpHeaders: BoxHTTPHeaders = [:],
        queryParams: QueryParameters = [:],
        body: BodyType = .empty,
        downloadDestination: URL? = nil,
        progress: @escaping (Progress) -> Void = { _ in }
    ) {
        self.httpMethod = httpMethod
        self.url = url
        self.httpHeaders = httpHeaders
        self.queryParams = queryParams
        self.body = body
        self.downloadDestination = downloadDestination
        self.progress = progress
    }
}

// MARK: - Request Endpoint Construction

extension BoxRequest {
    func endpoint() -> URL {

        if queryParams.isEmpty {
            return url
        }
        else {
            // swiftlint:disable:next force_unwrapping
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!

            let nonNullQueryParams: [String: String] = queryParams.compactMapValues { $0?.queryParamValue }
            components.setQueryItems(with: nonNullQueryParams) // Only set parameters with non-null values

            // swiftlint:disable:next force_unwrapping
            return components.url!
        }
    }

    func addBoxAPIRelatedHeaders(_ headers: BoxHTTPHeaders?) {
        guard let headers = headers else {
            return
        }
        httpHeaders = headers.reduce(into: httpHeaders) { result, header in result[header.0] = header.1 }
    }
}

extension BoxRequest {

    /// A description of the request body suitable for logging or debugging.  May not
    /// include the full contents of the body.
    var bodyDescription: Data? {

        switch body {
        case let .data(data):
            return data
        case let .jsonObject(jsonObject):
            return try? JSONSerialization.data(withJSONObject: jsonObject)
        case let .jsonArray(jsonArray):
            return try? JSONSerialization.data(withJSONObject: jsonArray)
        case let .urlencodedForm(params):
            return params
                .map { key, value in
                    String(
                        format: "%@=%@",
                        // swiftlint:disable:next force_unwrapping
                        key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                        // swiftlint:disable:next force_unwrapping
                        value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    )
                }
                .joined(separator: "&")
                .data(using: .utf8)
        case .multipart:
            return "Multipart".data(using: .utf8)
        case .empty:
            return Data()
        }
    }
}
