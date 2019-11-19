//
//  MetadataModule+Folders.swift
//  BoxSDK
//
//  Created by Daniel Cech on 28/06/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Extension for Metadata methods on Folders
public extension MetadataModule {

    /// Retrieve all metadata associated with a given folder
    ///
    /// - Parameters:
    ///   - folderId: The scope of metadata template - possible values are "global" or "enterprise_{id}"
    ///   - completion: Returns an array of metadata objects for particular folder or an error
    ///     if the scope or templateKey are invalid or the user doesn't have access to the template.
    func list(
        forFolderId folderId: String,
        completion: @escaping Callback<[MetadataObject]>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)/metadata", configuration: boxClient.configuration),
            completion: { result in
                let objectResult: Result<EntryContainer<MetadataObject>, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }
                let mappedResult: Result<[MetadataObject], BoxSDKError> = objectResult.map { $0.entries }
                completion(mappedResult)
            }
        )
    }

    /// Get the metadata instance for a folder.
    ///
    /// - Parameters:
    ///   - folderId: The scope of metadata template - possible values are "global" or "enterprise_{id}"
    ///   - scope: The scope of metadata template - possible values are "global" or "enterprise_{id}"
    ///   - templateKey: A unique identifier for the template.
    ///   - completion: Returns an array of metadata objects for particular folder or an error
    ///     if the scope or templateKey are invalid or the user doesn't have access to the template.
    func get(
        forFolderWithId folderId: String,
        scope: String,
        templateKey: String,
        completion: @escaping Callback<MetadataObject>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)/metadata/\(scope)/\(templateKey)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Create a metadata instance for a folder.
    ///
    /// - Parameters:
    ///   - folderId: The scope of metadata template - possible values are "global" or "enterprise_{id}"
    ///   - scope: The scope of metadata template - possible values are "global" or "enterprise_{id}"
    ///   - templateKey: A unique identifier for the template.
    ///   - completion: Returns an array of metadata objects for particular folder or an error
    ///     if the scope or templateKey are invalid or the user doesn't have access to the template.
    func create(
        forFolderWithId folderId: String,
        scope: String,
        templateKey: String,
        keys: [String: Any],
        completion: @escaping Callback<MetadataObject>
    ) {
        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)/metadata/\(scope)/\(templateKey)", configuration: boxClient.configuration),
            json: keys,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Update a metadata instance for a folder.
    ///
    /// - Parameters:
    ///   - folderId: The scope of metadata template - possible values are "global" or "enterprise_{id}"
    ///   - scope: The scope of metadata template - possible values are "global" or "enterprise_{id}"
    ///   - templateKey: A unique identifier for the template.
    ///   - completion: Returns an array of metadata objects for particular folder or an error
    ///     if the scope or templateKey are invalid or the user doesn't have access to the template.
    func update(
        forFolderWithId folderId: String,
        scope: String,
        templateKey: String,
        operations: [FolderMetadataOperation],
        completion: @escaping Callback<MetadataObject>
    ) {
        let json = operations.map { $0.json() }

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)/metadata/\(scope)/\(templateKey)", configuration: boxClient.configuration),
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Delete a metadata instance for a folder.
    ///
    /// - Parameters:
    ///   - folderId: The scope of metadata template - possible values are "global" or "enterprise_{id}"
    ///   - scope: The scope of metadata template - possible values are "global" or "enterprise_{id}"
    ///   - completion: Returns success or an error if the scope or templateKey are invalid or the
    ///         user doesn't have access to the template.
    func delete(
        forFolderWithId folderId: String,
        scope: String,
        templateKey: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/folders/\(folderId)/metadata/\(scope)/\(templateKey)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
