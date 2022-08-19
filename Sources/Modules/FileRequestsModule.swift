//
//  FileRequestsModule.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 09/08/2022.
//  Copyright © 2022 box. All rights reserved.
//

import Foundation

/// Provides management of FileRequests
public class FileRequestsModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Retrieves the information about a file request by ID.
    ///
    /// - Parameters:
    ///   - fileRequestId: The unique identifier that represent a file request.
    ///   - completion: Returns a FileRequest response object if successful otherwise a BoxSDKError.
    public func get(
        fileRequestId: String,
        completion: @escaping Callback<FileRequest>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/file_requests/\(fileRequestId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Updates a file request. This can be used to activate or deactivate a file request.
    ///
    /// - Parameters:
    ///   - fileRequestId: The unique identifier that represent a file request.
    ///   - ifMatch: Ensures this item hasn't recently changed before making changes.
    ///   Pass in the item's last observed `etag` value into this header and the endpoint will fail with a `412 Precondition Failed` if it has changed since. (optional)
    ///   - updateRequest: The `FileRequestUpdateRequest` object which provides the fields that can be updated.
    ///   - completion: Returns a FileRequest response object if successful otherwise a BoxSDKError.
    public func update(
        fileRequestId: String,
        ifMatch: String? = nil,
        updateRequest: FileRequestUpdateRequest,
        completion: @escaping Callback<FileRequest>
    ) {
        var headers: BoxHTTPHeaders = [:]
        if let unwrappedIfMatch = ifMatch {
            headers[BoxHTTPHeaderKey.ifMatch] = unwrappedIfMatch
        }

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/file_requests/\(fileRequestId)", configuration: boxClient.configuration),
            httpHeaders: headers,
            json: updateRequest.bodyDict,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Copies an existing file request that is already present on one folder, and applies it to another folder.
    ///
    /// - Parameters:
    ///   - fileRequestId: The unique identifier that represent a file request.
    ///   - copyRequest: The `FileRequestCopyRequest` object which provides required and optional fields used when copying, like: folder(required), title(optional), etc.
    ///   - completion: Returns a FileRequest response object if successful otherwise a BoxSDKError.
    public func copy(
        fileRequestId: String,
        copyRequest: FileRequestCopyRequest,
        completion: @escaping Callback<FileRequest>
    ) {
        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/file_requests/\(fileRequestId)/copy", configuration: boxClient.configuration),
            json: copyRequest.bodyDict,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Deletes a file request permanently.
    ///
    /// - Parameters:
    ///   - fileRequestId: The unique identifier that represent a file request.
    ///   - completion: Returns response object if successful otherwise a BoxSDKError.
    public func delete(
        fileRequestId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/file_requests/\(fileRequestId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
