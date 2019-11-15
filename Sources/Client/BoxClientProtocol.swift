//
//  BoxClientProtocol.swift
//  BoxSDK
//
//  Created by Abel Osorio on 3/26/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Defines methods for communication with Box APIs
public protocol BoxClientProtocol: AnyObject {

    /// Performs an HTTP GET method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - completion: Returns a BoxResponse object or an error if request fails
    func get(
        url: URL,
        httpHeaders: BoxHTTPHeaders,
        queryParameters: QueryParameters,
        completion: @escaping Callback<BoxResponse>
    )

    /// Performs an HTTP POST method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - json: The JSON body of the request
    ///   - completion: Returns a BoxResponse object or an error if request fails
    func post(
        url: URL,
        httpHeaders: BoxHTTPHeaders,
        queryParameters: QueryParameters,
        json: Any?,
        completion: @escaping Callback<BoxResponse>
    )

    /// Performs an HTTP POST method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - multipartBody: The multipart form body of the request
    ///   - progress: Closure where upload progress will be reported
    ///   - completion: Returns a BoxResponse object or an error if request fails
    func post(
        url: URL,
        httpHeaders: BoxHTTPHeaders,
        queryParameters: QueryParameters,
        multipartBody: MultipartForm,
        progress: @escaping (Progress) -> Void,
        completion: @escaping Callback<BoxResponse>
    )

    /// Performs an HTTP PUT method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - json: The JSON body of the request
    ///   - completion: Returns a BoxResponse object or an error if request fails
    func put(
        url: URL,
        httpHeaders: BoxHTTPHeaders,
        queryParameters: QueryParameters,
        json: Any?,
        completion: @escaping Callback<BoxResponse>
    )

    /// Performs an HTTP PUT method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - multipartBody: The multipart form body of the request
    ///   - progress: Closure where upload progress will be reported
    ///   - completion: Returns a BoxResponse object or an error if request fails
    func put(
        url: URL,
        httpHeaders: BoxHTTPHeaders,
        queryParameters: QueryParameters,
        multipartBody: MultipartForm,
        progress: @escaping (Progress) -> Void,
        completion: @escaping Callback<BoxResponse>
    )

    /// Performs an HTTP PUT method call on an API endpoint and returns a response - variant for chunked upload.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - data: Binary body of the request
    ///   - progress: Closure where upload progress will be reported
    ///   - completion: Returns a BoxResponse object or an error if request fails
    func put(
        url: URL,
        httpHeaders: BoxHTTPHeaders,
        queryParameters: QueryParameters,
        data: Data,
        progress: @escaping (Progress) -> Void,
        completion: @escaping Callback<BoxResponse>
    )

    /// Performs an HTTP OPTIONS method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - json: The JSON body of the request
    ///   - completion: Returns a BoxResponse object or an error if request fails
    func options(
        url: URL,
        httpHeaders: BoxHTTPHeaders,
        queryParameters: QueryParameters,
        json: Any?,
        completion: @escaping Callback<BoxResponse>
    )

    /// Performs an HTTP DELETE method call on an API endpoint and returns a response.
    ///
    /// - Parameters:
    ///   - url: The URL of the API endpoint to call.
    ///   - httpHeaders: Additional information to be passed in the HTTP headers of the request.
    ///   - queryParameters: Additional parameters to be passed in the URL that is called.
    ///   - completion: Returns a BoxResponse object or an error if request fails
    func delete(
        url: URL,
        httpHeaders: BoxHTTPHeaders,
        queryParameters: QueryParameters,
        completion: @escaping Callback<BoxResponse>
    )
}
