//
//  FilesModule.swift
//  BoxSDK-iOS
//
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Box item status indicating whether this item is deleted or not.
public enum ItemStatus: BoxEnum {
    /// Item was not deleted or moved to trash.
    case active
    /// Item has been moved to the trash
    case trashed
    /// Item has been permanently deleted
    case deleted
    /// Custom value for enum values not yet implemented in the SDK
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "active":
            self = .active
        case "trashed":
            self = .trashed
        case "deleted":
            self = .deleted
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .active:
            return "active"
        case .trashed:
            return "trashed"
        case .deleted:
            return "deleted"
        case let .customValue(value):
            return value
        }
    }
}

/// Defines the file extension of a thumbnail image file.
public enum ThumbnailExtension: BoxEnum {
    /// The file extension for Joint Photographic Experts Group (JPEG) thumbnail images
    case jpg
    /// The file extension for Portable Network Graphic (PNG) thumbnail images
    case png
    /// A custom file extension for thumbnail images that is not yet implemented. Check the list of
    /// [supported types](http://community.box.com/t5/Managing-Your-Content/What-file-types-are-supported-by-Box-s-Content-Preview/ta-p/327)
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "jpg":
            self = .jpg
        case "png":
            self = .png
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of suffix
    public var description: String {
        switch self {
        case .jpg:
            return "jpg"
        case .png:
            return "png"
        case let .customValue(value):
            return value
        }
    }
}

/// Provides [File](../Structs/File.html) management.
public class FilesModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Get information about a file.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file on which to retrieve information.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.  Any attribute in the full
    ///     [file](https://developer.box.com/reference#file-object) be
    ///     passed in with the fields parameter to get specific attributes, and only those specific
    ///     attributes back; otherwise, the mini format is returned for each item by default.
    ///   - completion: Returns a standard file object or an error if the fileId is invalid or the
    ///     user doesn't have access to the file.
    public func get(
        fileId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<File>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Update the information about a file, including renaming or moving the file.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file on which to perform the update.
    ///   - updateFileInfo: The new values with which to update the file.
    ///   - ifMatch: This is in the ‘etag’ field of the file object, which can be included to prevent race conditions.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.  Any attribute in the full
    ///     [file](https://developer.box.com/reference#file-object) be
    ///     passed in with the fields parameter to get specific attributes, and only those specific
    ///     attributes back; otherwise, the mini format is returned for each item by default.
    ///   - completion: Returns a standard file object or an error if the fileId is invalid or the
    ///     user doesn't have access to the file.
    public func update(
        fileId: String,
        name: String? = nil,
        description: String? = nil,
        parentId: String? = nil,
        sharedLink: NullableParameter<SharedLinkData>? = nil,
        tags: [String]? = nil,
        collections: [String]? = nil,
        lock: NullableParameter<LockData>? = nil,
        ifMatch: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<File>
    ) {

        var headers: BoxHTTPHeaders = [:]
        if let unwrappedIfMatch = ifMatch {
            headers[BoxHTTPHeaderKey.ifMatch] = unwrappedIfMatch
        }

        var body: [String: Any] = [:]
        body["name"] = name
        body["description"] = description

        if let unwrappedParentID = parentId {
            body["parent"] = ["id": unwrappedParentID]
        }

        if let unwrappedSharedLink = sharedLink {
            switch unwrappedSharedLink {
            case .null:
                body["shared_link"] = NSNull()
            case let .value(sharedLinkValue):
                body["shared_link"] = sharedLinkValue.bodyDict
            }
        }

        body["tags"] = tags
        body["collections"] = collections?.map { ["id": $0] }

        if let unwrappedLock = lock {
            switch unwrappedLock {
            case .null:
                body["lock"] = NSNull()
            case let .value(lockValue):
                body["lock"] = lockValue.bodyDict
            }
        }

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)", configuration: boxClient.configuration),
            httpHeaders: headers,
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    // swiftlint:enable cyclomatic_complexity

    /// Create a copy of a file in another folder. The original version of the file will not be
    /// altered.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the source file to copy.
    ///   - parentId: The ID of the destination folder.
    ///   - name: An optional new name for the file. Box supports file names of 255 characters or
    ///     less. Names containing non-printable ASCII characters, "/" or "\", names with trailing
    ///     spaces, and the special names “.” and “..” are also not allowed.
    ///   - version: An optional file version ID if you want to copy a specific file version
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.  Any attribute in the full
    ///     [file](https://developer.box.com/reference#file-object) be
    ///     passed in with the fields parameter to get specific attributes, and only those specific
    ///     attributes back; otherwise, the mini format is returned for each item by default.
    ///   - completion: Returns a standard file object or an error if the fileId is invalid or the
    ///     update is not successful. An error will be returned if the destination folder is
    ///     invalid or if a file name collision occurs.
    public func copy(
        fileId: String,
        parentId: String,
        name: String? = nil,
        version: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<File>
    ) {

        var json: [String: Any] = [
            "parent": [
                "id": parentId
            ]
        ]
        json["name"] = name
        json["version"] = version

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/copy", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Upload a file to a specified folder.
    ///
    /// - Parameters:
    ///   - name: The name of the file. Box supports file names of 255 characters or
    ///     less. Names containing non-printable ASCII characters, "/" or "\", names with trailing
    ///     spaces, and the special names “.” and “..” are also not allowed.
    ///   - parentId: The ID of the parent folder. Use "0" for the root folder.
    ///   - performPreflightCheck: Defines whether to first perform prelfight check request to decide whether file of this size
    ///     can be uploaded and whether specified name is unique and won't cause conflicts.
    ///   - completion: Returns a standard file object or an error if the parentId is invalid or if a file
    ///     name collision occurs.
    public func upload(
        data: Data,
        name: String,
        parentId: String,
        progress: @escaping (Progress) -> Void = { _ in },
        performPreflightCheck: Bool = false,
        completion: @escaping Callback<File>
    ) {
        uploadWithPreflightCheck(
            performCheck: performPreflightCheck,
            name: name,
            size: Int64(data.count),
            parentId: parentId,
            request: { [weak self] in
                guard let self = self else {
                    return
                }
                self.upload(data: data, name: name, parentId: parentId, progress: progress, completion: completion)
            }, completion: completion
        )
    }

    /// Uploads file without preflight check
    private func upload(
        data: Data,
        name: String,
        parentId: String,
        progress: @escaping (Progress) -> Void = { _ in },
        completion: @escaping Callback<File>
    ) {

        let attributes: [String: Any] = [
            "name": name,
            "parent": [
                "id": parentId
            ]
        ]

        var body = MultipartForm()
        do {
            body.appendPart(name: "attributes", contents: try JSONSerialization.data(withJSONObject: attributes))
            body.appendFilePart(name: "file", contents: InputStream(data: data), length: data.count, fileName: "UNUSED", mimeType: "application/octet-stream")
        }
        catch {
            completion(.failure(BoxCodingError(message: "Error with encoding multipart from", error: error)))
            return
        }

        boxClient.post(
            url: URL.boxUploadEndpoint("/api/2.0/files/content", configuration: boxClient.configuration),
            multipartBody: body,
            progress: progress,
            completion: ResponseHandler.unwrapCollection(wrapping: completion)
        )
    }

    /// Upload a file to a specified folder.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - name: The name of the file. Box supports file names of 255 characters or
    ///     less. Names containing non-printable ASCII characters, "/" or "\", names with trailing
    ///     spaces, and the special names “.” and “..” are also not allowed.
    ///   - performPreflightCheck: Checks whether new file version will be accepted before whole new version is uploaded.
    ///   - completion: Returns a standard file object or an error.
    public func uploadVersion(
        forFile fileId: String,
        name: String? = nil,
        contentModifiedAt: String? = nil,
        data: Data,
        progress: @escaping (Progress) -> Void = { _ in },
        performPreflightCheck: Bool = false,
        completion: @escaping Callback<File>
    ) {
        updateWithPreflightCheck(
            performCheck: performPreflightCheck,
            fileId: fileId,
            name: name,
            size: Int64(data.count),
            request: { [weak self] in

                guard let self = self else {
                    return
                }

                self.uploadVersion(
                    forFile: fileId,
                    name: name,
                    contentModifiedAt: contentModifiedAt,
                    data: data,
                    progress: progress,
                    completion: completion
                )
            }, completion: completion
        )
    }

    /// Upload request without preflight check.
    private func uploadVersion(
        forFile fileId: String,
        name: String? = nil,
        contentModifiedAt: String? = nil,
        data: Data,
        progress: @escaping (Progress) -> Void = { _ in },
        completion: @escaping Callback<File>
    ) {
        var attributes: [String: Any] = [:]
        attributes["name"] = name
        attributes["content_modified_at"] = contentModifiedAt

        var body = MultipartForm()
        do {
            body.appendPart(name: "attributes", contents: try JSONSerialization.data(withJSONObject: attributes))
            body.appendFilePart(name: "file", contents: InputStream(data: data), length: data.count, fileName: "UNUSED", mimeType: "application/octet-stream")
        }
        catch {
            completion(.failure(BoxCodingError(message: "Error with encoding multipart from", error: error)))
            return
        }

        boxClient.post(
            url: URL.boxUploadEndpoint("/api/2.0/files/\(fileId)/content", configuration: boxClient.configuration),
            multipartBody: body,
            progress: progress,
            completion: ResponseHandler.unwrapCollection(wrapping: completion)
        )
    }

    /// Upload a file to a specified folder.
    ///
    /// - Parameters:
    ///   - stream: An InputStream of data for been uploaded.
    ///   - dataLength: The lenght of the InputStream
    ///   - parentId: The ID of the parent folder. Use "0" for the root folder.
    ///   - name: The name of the file. Box supports file names of 255 characters or
    ///     less. Names containing non-printable ASCII characters, "/" or "\", names with trailing
    ///     spaces, and the special names “.” and “..” are also not allowed.
    ///   - performPreflightCheck: Defines whether to perform preflight request first check to see whether uploaded file parameters
    ///     such as size and name won't cause an upload error.
    ///   - completion: Returns a standard file object or an error if the parentId is invalid or if a file
    ///     name collision occurs.
    public func streamUpload(
        stream: InputStream,
        fileSize: Int,
        name: String,
        parentId: String,
        progress: @escaping (Progress) -> Void = { _ in },
        performPreflightCheck: Bool = false,
        completion: @escaping Callback<File>
    ) {
        uploadWithPreflightCheck(
            performCheck: performPreflightCheck,
            name: name,
            size: Int64(fileSize),
            parentId: parentId,
            request: { [weak self] in
                guard let self = self else {
                    return
                }
                self.streamUpload(
                    stream: stream,
                    fileSize: fileSize,
                    name: name,
                    parentId: parentId,
                    progress: progress,
                    completion: completion
                )
            },
            completion: completion
        )
    }

    /// Stream upload request without preflight check.
    private func streamUpload(
        stream: InputStream,
        fileSize: Int,
        name: String,
        parentId: String,
        progress: @escaping (Progress) -> Void = { _ in },
        completion: @escaping Callback<File>
    ) {

        let attributes: [String: Any] = [
            "name": name,
            "parent": [
                "id": parentId
            ]
        ]

        var body = MultipartForm()
        do {
            body.appendPart(name: "attributes", contents: try JSONSerialization.data(withJSONObject: attributes))
            body.appendFilePart(name: "file", contents: stream, length: fileSize, fileName: "UNUSED", mimeType: "application/octet-stream")
        }
        catch {
            completion(.failure(BoxCodingError(message: "Error with encoding multipart from", error: error)))
            return
        }

        boxClient.post(
            url: URL.boxUploadEndpoint("/api/2.0/files/content", configuration: boxClient.configuration),
            multipartBody: body,
            progress: progress,
            completion: ResponseHandler.unwrapCollection(wrapping: completion)
        )
    }

    /// Verifies that new file will be accepted by Box before you send all the bytes over the wire.
    /// Verifies all permissions as if the file was actually uploaded including: folder upload permission, file name collisions, file size caps,
    /// folder and file name restrictions, folder and account storage quota.
    ///
    /// - Parameters:
    ///   - name: The name of the file
    ///   - parantId: The ID of the parent folder. Use "0" for the root folder.
    ///   - size: The size of the file in bytes
    ///   - completion: Returns a empty resppnse in case of the checks have been passed and user can proceed to make a upload call or an error.
    public func preflightCheck(
        name: String,
        parentId: String,
        size: Int64? = nil,
        completion: @escaping Callback<Void>
    ) {
        var body: [String: Any] = ["parent": ["id": parentId]]
        body["name"] = name
        body["size"] = size

        boxClient.options(
            url: URL.boxAPIEndpoint("/2.0/files/content", configuration: boxClient.configuration),
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    // For chaining with follow up request in case of success.
    private func uploadWithPreflightCheck<T>(
        performCheck: Bool,
        name: String,
        size: Int64? = nil,
        parentId: String,
        request: @escaping () -> Void,
        completion: @escaping Callback<T>
    ) {
        if performCheck {
            preflightCheck(name: name, parentId: parentId, size: size) { result in
                switch result {
                case .success:
                    request()
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
        else {
            request()
        }
    }

    /// Verifies that an updated file will be accepted by Box before you send all the bytes over the wire. It's used before
    /// uploading new versions of an existing File.
    /// Verifies all permissions as if the file was actually uploaded including: folder upload permission, file name collisions, file size caps,
    /// folder and file name restrictions, folder and account storage quota.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the updated file.
    ///   - name: The name of the file.
    ///   - parantId: The ID of the parent folder. Use "0" for the root folder.
    ///   - size: The size of the file in bytes
    ///   - completion: Returns a empty response in case of the checks have been passed and user can proceed to make a upload call or an error.
    public func preflightCheckForNewVersion(
        forFile fileId: String,
        name: String? = nil,
        size: Int64? = nil,
        completion: @escaping Callback<Void>
    ) {
        var body: [String: Any] = [:]
        body["name"] = name
        body["size"] = size

        boxClient.options(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/content", configuration: boxClient.configuration),
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    private func updateWithPreflightCheck<T>(
        performCheck: Bool,
        fileId: String,
        name: String? = nil,
        size: Int64? = nil,
        request: @escaping () -> Void,
        completion: @escaping Callback<T>
    ) {
        if performCheck {
            preflightCheckForNewVersion(forFile: fileId, name: name, size: size) { result in
                switch result {
                case .success:
                    request()
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
        else {
            request()
        }
    }

    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - expiresAt: The time the lock expires
    ///   - isDownloadPrevented: Whether or not the file can be downloaded while locked
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.  Any attribute in the full
    ///     [file](https://developer.box.com/reference#file-object) be
    ///     passed in with the fields parameter to get specific attributes, and only those specific
    ///     attributes back; otherwise, the mini format is returned for each item by default.
    ///   - completion: Returns a standard file object or an error
    public func lock(
        fileId: String,
        expiresAt: Date? = nil,
        isDownloadPrevented: Bool? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<File>
    ) {
        update(
            fileId: fileId,
            lock: .value(LockData(
                expiresAt: expiresAt,
                isDownloadPrevented: isDownloadPrevented
            )),
            fields: fields,
            completion: completion
        )
    }

    /// Unlock  a file.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.  Any attribute in the full
    ///     [file](https://developer.box.com/reference#file-object) be
    ///     passed in with the fields parameter to get specific attributes, and only those specific
    ///     attributes back; otherwise, the mini format is returned for each item by default.
    ///   - completion: Returns a standard file object or an error
    public func unlock(
        fileId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<File>
    ) {
        update(fileId: fileId, lock: .null, fields: fields, completion: completion)
    }

    /// Get a thumbnail image for a file.
    // Sizes of 32x32, 64x64, 128x128, and 256x256 can be returned in the .png format and sizes of 32x32, 94x94,
    // 160x160, and 320x320 can be returned in the .jpg format. Thumbnails can be generated for the image and video
    // file formats listed on (http://community.box.com/t5/Managing-Your-Content/What-file-types-are-supported-by-Box-s-Content-Preview/ta-p/327)
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - extension: Specifies the thumbnail image file extension
    ///   - minHeight: The minimum height of the thumbnail
    ///   - minWidth: The minimum width of the thumbnail
    ///   - maxHeight: The maximum height of the thumbnail
    ///   - maxWidth: The maximum width of the thumbnail
    public func getThumbnail(
        forFile fileId: String,
        extension: ThumbnailExtension,
        minHeight: Int? = nil,
        minWidth: Int? = nil,
        maxHeight: Int? = nil,
        maxWidth: Int? = nil,
        completion: @escaping Callback<Data>
    ) {

        let queryParams = [
            "min_height": minHeight,
            "min_width": minWidth,
            "max_height": maxHeight,
            "max_width": maxWidth
        ]
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/thumbnail.\(`extension`)", configuration: boxClient.configuration),
            queryParameters: queryParams
        ) { result in
            completion(result.flatMap { response in
                guard let imageData = response.body else {
                    return .failure(BoxAPIError(message: .notFound("Thumbnail image is not returned"), response: response))
                }
                return .success(imageData)
            })
        }
    }

    /// Get a URL for creating an embedded preview session.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.  Any attribute in the full
    ///     [file](https://developer.box.com/reference#file-object) be
    ///     passed in with the fields parameter to get specific attributes, and only those specific
    ///     attributes back; otherwise, the mini format is returned for each item by default.
    ///   - completion: Returns a standard embed link or an error
    public func getEmbedLink(
        forFile fileId: String,
        completion: @escaping Callback<ExpiringEmbedLink>
    ) {
        get(fileId: fileId, fields: ["expiring_embed_link"]) { result in
            completion(FilesModule.unwrapEmbedLinkObject(from: result))
        }
    }

    /// Get all of the collaborations on a file (i.e. all of the users that have access to that file).
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details. This
    ///     parameter cannot be used simultaneously with the 'offset' parameter.
    ///   - limit: The maximum number of items to return
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.  Any attribute in the full
    ///     [file](https://developer.box.com/reference#file-object) be
    ///     passed in with the fields parameter to get specific attributes, and only those specific
    ///     attributes back; otherwise, the mini format is returned for each item by default.
    public func listCollaborations(
        forFile fileId: String,
        marker: String? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<Collaboration>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/collaborations", configuration: boxClient.configuration),
            queryParameters: [
                "marker": marker,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Get all of the comments on a file.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - offset: The offset of the item at which to begin the response. See [offset-based paging]
    ///     (https://developer.box.com/reference#section-offset-based-paging) for details. This
    ///     parameter cannot be used simultaneously with the 'marker' parameter.
    ///   - limit: The maximum number of items to return.
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.  Any attribute in the full
    ///     [file](https://developer.box.com/reference#file-object) be
    ///     passed in with the fields parameter to get specific attributes, and only those specific
    ///     attributes back; otherwise, the mini format is returned for each item by default.
    /// - Returns: Returns all of the comments on the file using offset-based paging.
    public func listComments(
        forFile fileId: String,
        offset: Int?,
        limit: Int?,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<Comment>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/comments", configuration: boxClient.configuration),
            queryParameters: [
                "offset": offset,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Get all of the tasks for a file.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - fields: String array of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.  Any attribute in the full
    ///     [file](https://developer.box.com/reference#file-object) be
    ///     passed in with the fields parameter to get specific attributes, and only those specific
    ///     attributes back; otherwise, the mini format is returned for each item by default.
    ///   - completion: Returns all of the tasks on the file
    public func listTasks(
        forFile fileId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<Task>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/tasks", configuration: boxClient.configuration),
            queryParameters: [
                "offset": 0,
                "limit": 1000,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Download a file to a specified folder.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - destinationURL: A URL for the location on device that we want to store the file once been donwloaded
    ///   - version: Optional file version ID to download (defaults to the current version)
    ///   - completion: Returns an empty response or an error
    public func download(
        fileId: String,
        destinationURL: URL,
        version: String? = nil,
        progress: @escaping (Progress) -> Void = { _ in },
        completion: @escaping Callback<Void>
    ) {

        boxClient.download(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/content", configuration: boxClient.configuration),
            downloadDestinationURL: destinationURL,
            queryParameters: ["version": version],
            progress: progress,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Discards a file to the trash. The `etag` of the file can be included as an ‘If-Match’ header to prevent race conditions.
    /// Depending on the enterprise settings for this user, the item will either be actually deleted from Box or moved to the trash.
    ///
    /// - Parameters:
    ///   - fileId: Id of the file that should be deleted.
    ///   - ifMatch: The etag of the file. This is in the `etag` field of the file object.
    ///   - completion: Empty response in case of success or an error.
    public func delete(
        fileId: String,
        ifMatch: String? = nil,
        completion: @escaping Callback<Void>
    ) {
        var headers: BoxHTTPHeaders = [:]
        if let unwrappedIfMatch = ifMatch {
            headers[BoxHTTPHeaderKey.ifMatch] = unwrappedIfMatch
        }

        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)", configuration: boxClient.configuration),
            httpHeaders: headers,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Add file to favorites
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - completion: Returns the updated file or an error
    public func addToFavorites(
        fileId: String,
        completion: @escaping Callback<File>
    ) {
        boxClient.collections.getFavorites { [weak self] result in
            guard let self = self else {
                completion(.failure(BoxSDKError(message: .instanceDeallocated("Unable to add to Favorites - FilesModule deallocated"))))
                return
            }

            switch result {
            case let .success(favorites):
                self.addToCollection(fileId: fileId, collectionId: favorites.id, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Add file to particular collection
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - collectionId: The ID of the collection
    ///   - completion: Returns the updated file or an error
    public func addToCollection(
        fileId: String,
        collectionId: String,
        completion: @escaping Callback<File>
    ) {
        get(fileId: fileId) { [weak self] result in
            guard let self = self else {
                completion(.failure(BoxSDKError(message: .instanceDeallocated("Unable to add to Collection - FilesModule deallocated"))))
                return
            }

            switch result {
            case let .success(file):
                let collectionList = file.collections ?? []
                let collectionIdList = collectionList.compactMap { $0["id"] }
                let updatedCollectionIdList = Array(Set(collectionIdList + [collectionId])) // Add only new

                self.update(fileId: fileId, collections: updatedCollectionIdList, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Remove file from favorites
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - completion: Returns the updated file or an error
    public func removeFromFavorites(
        fileId: String,
        completion: @escaping Callback<File>
    ) {
        boxClient.collections.getFavorites { [weak self] result in
            guard let self = self else {
                completion(.failure(BoxSDKError(message: .instanceDeallocated("Unable to remove from Favorites - FilesModule deallocated"))))
                return
            }

            switch result {
            case let .success(favorites):
                self.removeFromCollection(fileId: fileId, collectionId: favorites.id, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Add file to particular collection
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - collectionId: The ID of the collection
    ///   - completion: Returns the updated file or an error
    public func removeFromCollection(
        fileId: String,
        collectionId: String,
        completion: @escaping Callback<File>
    ) {
        get(fileId: fileId) { [weak self] result in
            guard let self = self else {
                completion(.failure(BoxSDKError(message: .instanceDeallocated("Unable to remove from Collection - FilesModule deallocated"))))
                return
            }

            switch result {
            case let .success(file):
                let collectionList = file.collections ?? []
                var collectionIdList = collectionList.compactMap { $0["id"] }

                if let index = collectionIdList.firstIndex(of: collectionId) {
                    collectionIdList.remove(at: index)
                }

                self.update(fileId: fileId, collections: collectionIdList, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Retrieves all file versions on a specified file.
    ///
    /// - Parameters:
    ///   - fileId: The id to retrieve all versions on.
    ///   - offset: The offset of the item at which to begin the response. See [offset-based paging]
    ///             (https://developer.box.com/reference#section-offset-based-paging) for details.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is 1,000.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    public func listVersions(
        fileId: String,
        offset: Int? = nil,
        limit: Int? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<PagingIterator<FileVersion>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/versions", configuration: boxClient.configuration),
            queryParameters: [
                "offset": offset,
                "limit": limit,
                "fields": FieldsQueryParam(fields)
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Retrieves a specified file version.
    ///
    /// - Parameters:
    ///   - fileId: The id the file the file version belongs to.
    ///   - fieldVersionId: The id of the file version to retrieve.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full file version object or an error.
    public func getVersion(
        fileId: String,
        fileVersionId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<FileVersion>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/versions/\(fileVersionId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Promotes the specified file version to the current file version.
    ///
    /// - Parameters:
    ///   - fileId: The id of the file the file version to promote belongs to.
    ///   - fileVersionId: The id of the file version to promote.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full file version object or an error.
    public func promoteVersion(
        fileId: String,
        fileVersionId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<FileVersion>
    ) {
        let body = [
            "type": "file_version",
            "id": fileVersionId
        ]

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/versions/current", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Discards the specified file version to the trash.
    ///
    /// - Parameters:
    ///   - fileId: The id of the file the file version to delete belongs to.
    ///   - fileVersionId: The file version to delete.
    ///   - ifMatch: The `etag` of the file version. This is unique to the file version and prevents simultaneous updates.
    ///   - completion: Returns a empty reponse or an error.
    public func deleteVersion(
        fileId: String,
        fileVersionId: String,
        ifMatch: String? = nil,
        completion: @escaping Callback<Void>
    ) {
        var headers: BoxHTTPHeaders = [:]
        if let unwrappedIfMatch = ifMatch {
            headers[BoxHTTPHeaderKey.ifMatch] = unwrappedIfMatch
        }

        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/versions/\(fileVersionId)", configuration: boxClient.configuration),
            httpHeaders: headers,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Retrieves the watermark on a specified file.
    ///
    /// - Parameters:
    ///   - fileId: The id of the file to retrieve the watermark from.
    ///   - completion: Returns a watermark object or an error.
    public func getWatermark(
        fileId: String,
        completion: @escaping Callback<Watermark>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/watermark", configuration: boxClient.configuration)
        ) { result in
            let objectResult: Result<Watermark.WatermarkResponse, BoxSDKError> = result.flatMap {
                ObjectDeserializer.deserialize(data: $0.body)
            }
            completion(Watermark.unwrapWatermarkObject(from: objectResult))
        }
    }

    /// Apply or update the watermark on a specified file.
    ///
    /// - Parameters:
    ///   - fileId: The id of the file to update the watermark for.
    ///   - completion: Returns a watermark object or an error.
    public func applyWatermark(
        fileId: String,
        completion: @escaping Callback<Watermark>
    ) {
        let body = [
            Watermark.resourceKey: [
                Watermark.imprintKey: Watermark.defaultImprint
            ]
        ]

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/watermark", configuration: boxClient.configuration),
            json: body
        ) { result in
            let objectResult: Result<Watermark.WatermarkResponse, BoxSDKError> = result.flatMap {
                ObjectDeserializer.deserialize(data: $0.body)
            }
            completion(Watermark.unwrapWatermarkObject(from: objectResult))
        }
    }

    /// Remove the watermark from a specified file.
    ///
    /// - Parameters:
    ///   - fileId: The id of the file to remove the watermark from.
    ///   - completion: Returns an empty response or an error.
    public func removeWatermark(
        fileId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/watermark", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Unwrap a EmbedLinkObject
    ///
    /// - Parameter result: Returns a standard collection of objects with the file object or an error
    /// - Returns: Returns a standard ExpiringEmbedLink object or an error
    static func unwrapEmbedLinkObject(from result: Result<File, BoxSDKError>) -> Result<ExpiringEmbedLink, BoxSDKError> {
        switch result {
        case let .success(file):
            guard let expiringEmbedLink = file.expiringEmbedLink else {
                return .failure(BoxSDKError(message: .notFound("Expiring embed link for file")))
            }
            return .success(expiringEmbedLink)
        case let .failure(error):
            return .failure(error)
        }
    }

    /// Gets file with updated shared link
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - completion: Returns a standard SharedLink object or an error
    public func getSharedLink(
        forFile fileId: String,
        completion: @escaping Callback<SharedLink>
    ) {
        get(fileId: fileId, fields: ["shared_link"], completion: { result in
            completion(FilesModule.unwrapSharedLinkObject(from: result))
        })
    }

    /// Creates of updates shared link for a file
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - stopSharingAt: The date-time that this link will become disabled. This field can only be set by users with paid accounts
    ///   - access: The level of access. If you omit this field then the access level will be set to the default access level specified by the enterprise admin
    ///   - password: The password required to access the shared link. Set to .empty to delete the password
    ///   - canDownload: Whether the shared link allows downloads
    ///   - completion: Returns a standard SharedLink object or an error
    public func setSharedLink(
        forFile fileId: String,
        unsharedAt: NullableParameter<Date>? = nil,
        access: SharedLinkAccess? = nil,
        password: NullableParameter<String>? = nil,
        canDownload: Bool? = nil,
        completion: @escaping Callback<SharedLink>
    ) {
        update(
            fileId: fileId,
            sharedLink: .value(SharedLinkData(
                access: access,
                password: password,
                unsharedAt: unsharedAt,
                canDownload: canDownload
            )),
            fields: ["shared_link"]
        ) { result in
            completion(FilesModule.unwrapSharedLinkObject(from: result))
        }
    }

    /// Removes shared link for a file
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - completion: Returns an empty response or an error
    public func deleteSharedLink(
        forFile fileId: String,
        completion: @escaping Callback<Void>
    ) {
        update(fileId: fileId, sharedLink: .null) { result in
            completion(result.map { _ in })
        }
    }

    /// Unwrap a SharedLink object from file
    ///
    /// - Parameter result: A standard collection of objects with the file object or an error
    /// - Returns: Returns a standard SharedLink object or an error
    static func unwrapSharedLinkObject(from result: Result<File, BoxSDKError>) -> Result<SharedLink, BoxSDKError> {
        switch result {
        case let .success(file):
            guard let sharedLink = file.sharedLink else {
                return .failure(BoxSDKError(message: .notFound("Shared link for file")))
            }
            return .success(sharedLink)
        case let .failure(error):
            return .failure(error)
        }
    }

    // swiftlint:disable:next file_length
}
