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

    /// Additional information to be passed in the HTTP headers of the request.
    public internal(set) var httpHeaders: BoxHTTPHeaders
    /// The HTTP request method (e.g. get, post, delete)
    public let httpMethod: HTTPMethod
    /// The URL of the API endpoint to call.
    public let url: URL
    /// Additional parameters to be passed in the URL that is called.
    public let queryParams: QueryParameters
    /// Body of the request.
    public let body: BodyType
    /// The closure that should add URLSessionTask to BoxNetworkTask store, in order to be able to cancel
    /// upload or download request during execution.
    public let task: (URLSessionTask) -> Void
    /// The closure where  progress of the request will be reported
    public let progress: (Progress) -> Void
    /// The URL  on the local FileSystem where a download request will write the data
    public let downloadDestination: URL?

    /// Initializer.
    ///
    /// - Parameters:
    ///   - httpMethod: The HTTP request method (e.g. get, post, delete)
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParams: Additional parameters to be passed in the URL that is called.
    ///   - body: Body of the request.
    ///   - downloadDestination: The URL on disk  where a download request will write the data
    ///     Please omit this parameter when not downloading a file.
    ///   - task: The closure that should add URLSessionTask to BoxNetworkTask store, in order to be able to cancel
    ///     upload or download request during execution.
    ///     You should use here `receiveTask` either from `BoxDownloadTask` or `BoxUploadTask` instance.
    ///     Then in order to cancel the request, call `cancel` method on this instance.
    ///     Please omit this parameter when you not intent to cancel upload or download a file.
    ///   - progress: Closure where  progress of the request will be reported
    public init(
        httpMethod: HTTPMethod,
        url: URL,
        httpHeaders: BoxHTTPHeaders = [:],
        queryParams: QueryParameters = [:],
        body: BodyType = .empty,
        downloadDestination: URL? = nil,
        task: @escaping (URLSessionTask) -> Void = { _ in },
        progress: @escaping (Progress) -> Void = { _ in }
    ) {
        self.httpMethod = httpMethod
        self.url = url
        self.httpHeaders = httpHeaders
        self.queryParams = queryParams
        self.body = body
        self.downloadDestination = downloadDestination
        self.task = task
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
