//
//  TrashModule.swift
//  BoxSDK
//
//  Created by Daniel Cech on 30/07/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Module for trash management
public class TrashModule {

    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Gets the files, folders and web links that are in the user's trash.
    ///
    /// - Parameters:
    ///   - offset: The offset of the item at which to begin the response. See [offset-based paging]
    ///     (https://developer.box.com/reference#section-offset-based-paging) for details.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func listItems(
        offset: Int? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<FolderItem>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/folders/trash/items", configuration: boxClient.configuration),
            queryParameters: [
                "offset": offset,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Get a file that has been moved to the trash.
    ///
    /// - Parameters:
    ///   - id: The identifier of file
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a file response object if successful otherwise a BoxSDKError.
    public func getFile(
        id: String,
        fields: [String]? = nil,
        completion: @escaping Callback<File>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/files/\(id)/trash", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get a folder that has been moved to the trash.
    ///
    /// - Parameters:
    ///   - id: The identifier of folder
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a folder response object if successful otherwise a BoxSDKError.
    public func getFolder(
        id: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Folder>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/folders/\(id)/trash", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get a web link that has been moved to the trash.
    ///
    /// - Parameters:
    ///   - id: The identifier of web link
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a web link response object if successful otherwise a BoxSDKError.
    public func getWebLink(
        id: String,
        fields: [String]? = nil,
        completion: @escaping Callback<WebLink>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/web_links/\(id)/trash", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Restores a file that has been moved to the trash.
    ///
    /// - Parameters:
    ///   - id: The identifier of file
    ///   - name: The new name for this file. Only used if file can't be restored with its
    ///     previous name due to a conflict.
    ///   - parentFolderId: The ID of the new parent folder. Only used if the previous parent
    ///     folder no longer exists or the user doesn't have permission to restore the file there.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a file response object if successful otherwise a BoxSDKError.
    public func restoreFile(
        id: String,
        name: String? = nil,
        parentFolderId: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<File>
    ) {
        var json = [String: Codable]()
        json["name"] = name
        if let unwrappedParentFolderId = parentFolderId {
            json["parent"] = ["id": unwrappedParentFolderId]
        }

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/files/\(id)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Restores a folder that has been moved to the trash.
    ///
    /// - Parameters:
    ///   - id: The identifier of folder
    ///   - name: The new name for this folder. Only used if folder can't be restored with its
    ///     previous name due to a conflict.
    ///   - parentFolderId: The ID of the new parent folder. Only used if the previous parent
    ///     folder no longer exists or the user doesn't have permission to restore the
    ///     folder there.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a folder response object if successful otherwise a BoxSDKError.
    public func restoreFolder(
        id: String,
        name: String? = nil,
        parentFolderId: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<Folder>
    ) {
        var json = [String: Codable]()
        json["name"] = name
        if let unwrappedParentFolderId = parentFolderId {
            json["parent"] = ["id": unwrappedParentFolderId]
        }

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/folders/\(id)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Restores a web link that has been moved to the trash.
    ///
    /// - Parameters:
    ///   - id: The identifier of web link
    ///   - name: The new name for this web link. Only used if the web link can't be restored with its
    ///     previous name due to a conflict.
    ///   - parentFolderId: The ID of the new parent folder. Only used if the previous parent
    ///     folder no longer exists or the user doesn't have permission to restore the
    ///     web link there.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a web link response object if successful otherwise a BoxSDKError.
    public func restoreWebLink(
        id: String,
        name: String? = nil,
        parentFolderId: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<WebLink>
    ) {
        var json = [String: Codable]()
        json["name"] = name
        if let unwrappedParentFolderId = parentFolderId {
            json["parent"] = ["id": unwrappedParentFolderId]
        }

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/web_links/\(id)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Permanently delete a file that is in the trash. The file will no longer exist in Box.
    /// This action cannot be undone.
    ///
    /// - Parameters:
    ///   - id: The identifier of file
    ///   - completion: Returns a success or a BoxSDKError.
    public func permanentlyDeleteFile(
        id: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/files/\(id)/trash", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Permanently delete a folder that is in the trash. The folder will no longer exist
    /// in Box. This action cannot be undone.
    ///
    /// - Parameters:
    ///   - id: The identifier of folder
    ///   - completion: Returns a success or a BoxSDKError.
    public func permanentlyDeleteFolder(
        id: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/folders/\(id)/trash", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Permanently delete a web link that is in the trash. The web link will no longer exist
    /// in Box. This action cannot be undone.
    ///
    /// - Parameters:
    ///   - id: The identifier of web link
    ///   - completion: Returns a success or a BoxSDKError.
    public func permanentlyDeleteWebLink(
        id: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/web_links/\(id)/trash", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
