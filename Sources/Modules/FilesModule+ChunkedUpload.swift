//
//  FilesModule.swift
//  BoxSDK-iOS
//
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Provides [File](../Structs/File.html) management.
public extension FilesModule {

    /// Create an upload session for uploading a new file.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder that will contain the new file.
    ///   - fileName: Name of new file.
    ///   - fileSize: The total number of bytes in the file to be uploaded.
    ///   - completion: Returns a upload session object or an error if upload session cannot be created,
    ///     for example when folder with specified ID doesn't exist
    func createUploadSession(
        folderId: String,
        fileName: String,
        fileSize: Int32,
        completion: @escaping Callback<UploadSession>
    ) {
        let json: [String: Any] = [
            "folder_id": folderId,
            "file_name": fileName,
            "file_size": fileSize
        ]

        boxClient.post(
            url: URL.boxUploadEndpoint("/api/2.0/files/upload_sessions", configuration: boxClient.configuration),
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Create an upload session for uploading a new file version.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file of which version is uploaded.
    ///   - fileName: Optional name of new file. If provided, the file name will be changed to this value upon successful upload.
    ///   - fileSize: The total number of bytes in the file to be uploaded.
    ///   - completion: Returns a upload session object or an error if upload session cannot be created
    func createUploadSessionForNewVersion(
        ofFile fileId: String,
        fileName: String? = nil,
        fileSize: Int32,
        completion: @escaping Callback<UploadSession>
    ) {
        var json = [String: Any]()
        json["file_name"] = fileName
        json["file_size"] = fileSize

        boxClient.post(
            url: URL.boxUploadEndpoint("/api/2.0/files/\(fileId)/upload_sessions", configuration: boxClient.configuration),
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Upload a part of the file to this session.
    ///
    /// - Parameters:
    ///   - sessionId: ID of upload session object.
    ///   - data: The part content as binary data.
    ///   - offset: The first byte of uploaded part
    ///   - totalSize: total size of uploaded data
    ///   - completion: Returns a upload part object or an error if part upload failed
    func uploadPart(
        sessionId: String,
        data: Data,
        offset: Int,
        totalSize: Int,
        progress: @escaping (Progress) -> Void = { _ in },
        completion: @escaping Callback<UploadPart>
    ) {
        let digest = data.sha1Base64Encoded()

        boxClient.put(
            url: URL.boxUploadEndpoint("/api/2.0/files/upload_sessions/\(sessionId)", configuration: boxClient.configuration),
            httpHeaders: [
                "digest": "sha=\(digest)",
                "content-range": "bytes \(offset)-\(offset + data.count - 1)/\(totalSize)"
            ],
            data: data,
            progress: progress,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get list of parts of chunked upload session.
    ///
    /// - Parameters:
    ///   - sessionId: ID of upload session object.
    ///   - offset: The offset of the item at which to begin the response. See [offset-based paging]
    ///     (https://developer.box.com/reference#section-offset-based-paging) for details.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    func listUploadSessionParts(
        sessionId: String,
        offset: Int? = nil,
        limit: Int? = nil,
        completion: @escaping Callback<PagingIterator<UploadPartDescription>>
    ) {
        boxClient.get(
            url: URL.boxUploadEndpoint("/api/2.0/files/upload_sessions/\(sessionId)/parts", configuration: boxClient.configuration),
            queryParameters: [
                "offset": offset,
                "limit": limit
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Commit upload session after successful upload of all parts.
    ///
    /// - Parameters:
    ///   - sessionId: ID of upload session object.
    ///   - parts: Array of upload part descriptions
    ///   - sha1: Base64 encoded SHA1 digest from the whole uploaded file.
    ///   - description: Optional. The description of this file.
    ///   - sharedLink: Optional. The shared link object for this file.
    ///   - tags: Optional. All tags applied to this file
    ///   - collections: Optional. The collections that the file belongs to
    ///   - lock: Optional. The lock held on this file. If there is no lock, this can either
    ///     be null or have a timestamp in the past.
    ///   - contentCreatedAt: Optional. When the content of this file was created.
    ///   - contentModifiedAt: Optional. When the content of this file was last modified.
    ///   - completion: Returns an array of files or an error if part upload failed
    func commitUpload(
        sessionId: String,
        parts: [UploadPartDescription],
        sha1: String,
        description: String? = nil,
        sharedLink: SharedLinkData? = nil,
        tags: [String]? = nil,
        collections: [String]? = nil,
        lock: LockData? = nil,
        contentCreatedAt: Date? = nil,
        contentModifiedAt: Date? = nil,
        completion: @escaping Callback<File>
    ) {
        var json = [String: Any]()

        json["parts"] = parts.map { $0.jsonRepresentation() }

        var attributes = [String: Any]()

        attributes["description"] = description
        attributes["shared_link"] = sharedLink
        attributes["tags"] = tags
        attributes["collections"] = collections?.map { ["id": $0] }
        attributes["lock"] = lock

        attributes["content_created_at"] = contentCreatedAt?.iso8601
        attributes["content_modified_at"] = contentModifiedAt?.iso8601

        json["attributes"] = attributes

        boxClient.post(
            url: URL.boxUploadEndpoint("/api/2.0/files/upload_sessions/\(sessionId)/commit", configuration: boxClient.configuration),
            httpHeaders: [
                "digest": "sha=\(sha1)"
            ],
            json: json,
            completion: ResponseHandler.unwrapCollection(wrapping: completion)
        )
    }

    /// Abort chunked upload session.
    ///
    /// - Parameters:
    ///   - sessionId: ID of upload session object.
    ///   - completion: Returns a success or an error if aborting failed
    func abortUpload(
        sessionId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxUploadEndpoint("/api/2.0/files/upload_sessions/\(sessionId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get chunked upload session with ID.
    ///
    /// - Parameters:
    ///   - sessionId: ID of existing chunked upload session.
    ///   - completion: Returns a upload session or an error if session cannot be returned
    func getUploadSession(
        sessionId: String,
        completion: @escaping Callback<UploadSession>
    ) {
        boxClient.get(
            url: URL.boxUploadEndpoint("/api/2.0/files/upload_sessions/\(sessionId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
