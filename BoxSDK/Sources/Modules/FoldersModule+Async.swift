//
//  FoldersModule+Async.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 18/05/2022.
//  Copyright © 2022 box. All rights reserved.
//

import Foundation

@available(iOS 13.0, macOS 10.15, *)
public extension FoldersModule {

    /// Get information about a folder.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder on which to retrieve information.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    /// - Returns: Folder object
    /// - Throws: BoxSDKError if the parentId is invalid or if a name collision occurs.
    func get(
        folderId: String,
        fields: [String]? = nil
    ) async throws -> Folder {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Folder>) in
            self.get(folderId: folderId, fields: fields, completion: callback)
        }
    }

    /// Create a new folder.
    ///
    /// - Parameters:
    ///   - name: The desired name for the folder.  Box supports folder names of 255 characters or
    ///     less. Names containing non-printable ASCII characters, "/" or "\", names with trailing
    ///     spaces, and the special names “.” and “..” are also not allowed.
    ///   - parentId: The ID of the parent folder.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    /// - Returns: A full folder object.
    /// - Throws: A BoxSDKError if the parentId is invalid or if a name collision occurs.
    func create(
        name: String,
        parentId: String,
        fields: [String]? = nil
    ) async throws -> Folder {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Folder>) in
            self.create(name: name, parentId: parentId, fields: fields, completion: callback)
        }
    }

    /// Update a folder.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the file to update
    ///   - name: The name of the folder.
    ///   - description: The description of the folder.
    ///   - parentId: The ID of the parent folder
    ///   - sharedLink: Shared links provide direct, read-only access to folder on Box using a URL.
    ///   - folderUploadEmailAccess: Can be open or collaborators
    ///   - tags: Array of tags to be added or replaced to the folder
    ///   - canNonOwnersInvite: If this parameter is set to false, only folder owners and co-owners can send collaborator invites
    ///   - isCollaborationRestrictedToEnterprise: Whether to restrict future collaborations to within the enterprise. Does not affect existing collaborations.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    /// - Returns: The updated folder is returned if the name is valid.
    /// - Throws: A BoxSDKError if the parentId is invalid or if a name collision occurs.
    func update(
        folderId: String,
        name: String? = nil,
        description: String? = nil,
        parentId: String? = nil,
        sharedLink: NullableParameter<SharedLinkData>? = nil,
        folderUploadEmailAccess: FolderUploadEmailAccess? = nil,
        tags: [String]? = nil,
        canNonOwnersInvite: Bool? = nil,
        isCollaborationRestrictedToEnterprise: Bool? = nil,
        collections: [String]? = nil,
        fields: [String]? = nil
    ) async throws -> Folder {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Folder>) in
            self.update(
                folderId: folderId,
                name: name,
                description: description,
                parentId: parentId,
                sharedLink: sharedLink,
                folderUploadEmailAccess: folderUploadEmailAccess,
                tags: tags,
                canNonOwnersInvite: canNonOwnersInvite,
                isCollaborationRestrictedToEnterprise: isCollaborationRestrictedToEnterprise,
                collections: collections,
                fields: fields,
                completion: callback
            )
        }
    }

    /// Delete a folder or move a folder to the trash. The recursive parameter must be included in
    /// order to delete folders that aren't empty. Depending on the [enterprise settings for this
    /// user](https://community.box.com/t5/Managing-Files-and-Folders/Trash/ta-p/19212), the item
    /// will either be actually deleted from Box or [moved to the trash]
    /// (https://developer.box.com/reference#get-the-items-in-the-trash).
    ///
    /// - Parameters:
    ///   - folderId: The ID of the file to delete.
    ///   - recursive: Whether to delete this folder if it has items inside of it.
    /// - Returns: An empty response will be returned upon successful deletion.
    /// - Throws: A BoxSDKError if the folder is not empty and the ‘recursive’ parameter is not included.
    func delete(folderId: String, recursive: Bool? = nil) async throws {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Void>) in
            self.delete(folderId: folderId, recursive: recursive, completion: callback)
        }
    }

    /// Create a copy of a folder in another folder. The original version of the folder will not be altered.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder that will be copy.
    ///   - destinationFolderId: The ID of the destination folder
    ///   - name: An optional new name for the folder
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    /// - Returns: The full folder object.
    /// - Throws: A BoxSDKError if a name collision occurs.
    func copy(
        folderId: String,
        destinationFolderId: String,
        name: String? = nil,
        fields: [String]? = nil
    ) async throws -> Folder {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Folder>) in
            self.copy(
                folderId: folderId,
                destinationFolderID: destinationFolderId,
                name: name,
                fields: fields,
                completion: callback
            )
        }
    }

    /// Add folder to favorites
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - fields: Comma-separated list of folder [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    /// - Returns: The updated folder.
    /// - Throws: BoxSDKError.
    func addToFavorites(
        folderId: String,
        fields: [String]? = nil
    ) async throws -> Folder {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Folder>) in
            self.addToFavorites(folderId: folderId, fields: fields, completion: callback)
        }
    }

    /// Add folder to particular collection
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - fields: Comma-separated list of folder [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    /// - Returns: The updated folder or an error
    /// - Throws: BoxSDKError
    func addToCollection(
        folderId: String,
        collectionId: String,
        fields: [String]? = nil
    ) async throws -> Folder {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Folder>) in
            self.addToCollection(
                folderId: folderId,
                collectionId: collectionId,
                fields: fields,
                completion: callback
            )
        }
    }

    /// Remove folder from favorites
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - fields: Comma-separated list of folder [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    /// - Returns: The updated folder or an error
    /// - Throws: BoxSDKError
    func removeFromFavorites(
        folderId: String,
        fields: [String]? = nil
    ) async throws -> Folder {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Folder>) in
            self.removeFromFavorites(
                folderId: folderId,
                fields: fields,
                completion: callback
            )
        }
    }

    /// Remove folder from particular collection
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - collectionId: The ID of the collection
    ///   - fields: Comma-separated list of folder [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    /// - Returns: The updated folder
    /// - Throws: BoxSDKError
    func removeFromCollection(
        folderId: String,
        collectionId: String,
        fields: [String]? = nil
    ) async throws -> Folder {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Folder>) in
            self.removeFromCollection(
                folderId: folderId,
                collectionId: collectionId,
                fields: fields,
                completion: callback
            )
        }
    }

    /// Gets folder with updated shared link
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    /// - Returns: The SharedLink object
    /// - Throws: BoxSDKError
    func getSharedLink(forFolder folderId: String) async throws -> SharedLink {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<SharedLink>) in
            self.getSharedLink(forFolder: folderId, completion: callback)
        }
    }

    /// Creates or updates shared link for a folder
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    ///   - access: The level of access. If you omit this field then the access level will be set to the default access level specified by the enterprise admin
    ///   - unsharedAt: The date-time that this link will become disabled. This field can only be set by users with paid accounts
    ///   - vanityName: The custom name of a shared link, as used in the vanityUrl field.
    ///     It should be between 12 and 30 characters. This field can contains only letters, numbers, and hyphens.
    ///   - password: The password required to access the shared link. Set to .null to remove the password
    ///   - canDownload: Whether the shared link allows downloads. Applies to any items in the folder
    /// - Returns: The SharedLink object
    /// - Throws: BoxSDKError
    func setSharedLink(
        forFolder folderId: String,
        access: SharedLinkAccess? = nil,
        unsharedAt: NullableParameter<Date>? = nil,
        vanityName: NullableParameter<String>? = nil,
        password: NullableParameter<String>? = nil,
        canDownload: Bool? = nil
    ) async throws -> SharedLink {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<SharedLink>) in
            self.setSharedLink(
                forFolder: folderId,
                access: access,
                unsharedAt: unsharedAt,
                vanityName: vanityName,
                password: password,
                canDownload: canDownload,
                completion: callback
            )
        }
    }

    /// Removes shared link for a folder
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder
    /// - Throws: BoxSDKError
    func deleteSharedLink(forFolder folderId: String) async throws {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Void>) in
            self.deleteSharedLink(forFolder: folderId, completion: callback)
        }
    }

    /// Retrieves the watermark on a specified folder.
    ///
    /// - Parameters:
    ///   - folderId: The id of the folder to retrieve the watermark from.
    /// - Returns: The Watermark object.
    /// - Throws: BoxSDKError
    func getWatermark(folderId: String) async throws -> Watermark {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Watermark>) in
            self.getWatermark(folderId: folderId, completion: callback)
        }
    }

    /// Apply or update the watermark on a specified folder.
    ///
    /// - Parameters:
    ///   - folderId: The id of the folder to update the watermark for.
    /// - Returns: The Watermark object.
    /// - Throws: BoxSDKError
    func applyWatermark(folderId: String) async throws -> Watermark {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Watermark>) in
            self.applyWatermark(folderId: folderId, completion: callback)
        }
    }

    /// Remove the watermark from a specified folder.
    ///
    /// - Parameters:
    ///   - folderId: The id of the folder to remove the watermark from.
    /// - Throws: BoxSDKError
    func removeWatermark(folderId: String) async throws {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Void>) in
            self.removeWatermark(folderId: folderId, completion: callback)
        }
    }

    /// Creates a folder lock on a folder, preventing it from being moved and/or deleted.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder to apply the lock to.
    /// - Returns: The Folder lock object
    /// - Throws: BoxSDKError
    func createLock(folderId: String) async throws -> FolderLock {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<FolderLock>) in
            self.createLock(folderId: folderId, completion: callback)
        }
    }

    /// Remove the specified folder lock.
    ///
    /// - Parameters:
    ///   - folderLockId: The id of the folder lock to remove.
    /// - Throws: BoxSDKError
    func deleteLock(folderLockId: String) async throws {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<Void>) in
            self.deleteLock(folderLockId: folderLockId, completion: callback)
        }
    }
}
