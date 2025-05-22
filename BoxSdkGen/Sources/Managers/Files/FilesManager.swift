import Foundation

public class FilesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves the details about a file.
    ///
    /// - Parameters:
    ///   - fileId: The unique identifier that represents a file.
    ///     
    ///     The ID for any file can be determined
    ///     by visiting a file in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/files/123`
    ///     the `file_id` is `123`.
    ///     Example: "12345"
    ///   - queryParams: Query parameters of getFileById method
    ///   - headers: Headers of getFileById method
    /// - Returns: The `FileFull`.
    /// - Throws: The `GeneralError`.
    public func getFileById(fileId: String, queryParams: GetFileByIdQueryParams = GetFileByIdQueryParams(), headers: GetFileByIdHeaders = GetFileByIdHeaders()) async throws -> FileFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-none-match": Utils.Strings.toString(value: headers.ifNoneMatch), "boxapi": Utils.Strings.toString(value: headers.boxapi), "x-rep-hints": Utils.Strings.toString(value: headers.xRepHints)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileFull.deserialize(from: response.data!)
    }

    /// Updates a file. This can be used to rename or move a file,
    /// create a shared link, or lock a file.
    ///
    /// - Parameters:
    ///   - fileId: The unique identifier that represents a file.
    ///     
    ///     The ID for any file can be determined
    ///     by visiting a file in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/files/123`
    ///     the `file_id` is `123`.
    ///     Example: "12345"
    ///   - requestBody: Request body of updateFileById method
    ///   - queryParams: Query parameters of updateFileById method
    ///   - headers: Headers of updateFileById method
    /// - Returns: The `FileFull`.
    /// - Throws: The `GeneralError`.
    public func updateFileById(fileId: String, requestBody: UpdateFileByIdRequestBody = UpdateFileByIdRequestBody(), queryParams: UpdateFileByIdQueryParams = UpdateFileByIdQueryParams(), headers: UpdateFileByIdHeaders = UpdateFileByIdHeaders()) async throws -> FileFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-match": Utils.Strings.toString(value: headers.ifMatch)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileFull.deserialize(from: response.data!)
    }

    /// Deletes a file, either permanently or by moving it to
    /// the trash.
    /// 
    /// The the enterprise settings determine whether the item will
    /// be permanently deleted from Box or moved to the trash.
    ///
    /// - Parameters:
    ///   - fileId: The unique identifier that represents a file.
    ///     
    ///     The ID for any file can be determined
    ///     by visiting a file in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/files/123`
    ///     the `file_id` is `123`.
    ///     Example: "12345"
    ///   - headers: Headers of deleteFileById method
    /// - Throws: The `GeneralError`.
    public func deleteFileById(fileId: String, headers: DeleteFileByIdHeaders = DeleteFileByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-match": Utils.Strings.toString(value: headers.ifMatch)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Creates a copy of a file.
    ///
    /// - Parameters:
    ///   - fileId: The unique identifier that represents a file.
    ///     
    ///     The ID for any file can be determined
    ///     by visiting a file in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/files/123`
    ///     the `file_id` is `123`.
    ///     Example: "12345"
    ///   - requestBody: Request body of copyFile method
    ///   - queryParams: Query parameters of copyFile method
    ///   - headers: Headers of copyFile method
    /// - Returns: The `FileFull`.
    /// - Throws: The `GeneralError`.
    public func copyFile(fileId: String, requestBody: CopyFileRequestBody, queryParams: CopyFileQueryParams = CopyFileQueryParams(), headers: CopyFileHeaders = CopyFileHeaders()) async throws -> FileFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/copy")", method: "POST", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileFull.deserialize(from: response.data!)
    }

    /// Retrieves a thumbnail, or smaller image representation, of a file.
    /// 
    /// Sizes of `32x32`,`64x64`, `128x128`, and `256x256` can be returned in
    /// the `.png` format and sizes of `32x32`, `160x160`, and `320x320`
    /// can be returned in the `.jpg` format.
    /// 
    /// Thumbnails can be generated for the image and video file formats listed
    /// [found on our community site][1].
    /// 
    /// [1]: https://community.box.com/t5/Migrating-and-Previewing-Content/File-Types-and-Fonts-Supported-in-Box-Content-Preview/ta-p/327
    ///
    /// - Parameters:
    ///   - fileId: The unique identifier that represents a file.
    ///     
    ///     The ID for any file can be determined
    ///     by visiting a file in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/files/123`
    ///     the `file_id` is `123`.
    ///     Example: "12345"
    ///   - extension_: The file format for the thumbnail
    ///     Example: "png"
    ///   - downloadDestinationUrl: The URL on disk where the file will be saved once it has been downloaded.
    ///   - queryParams: Query parameters of getFileThumbnailById method
    ///   - headers: Headers of getFileThumbnailById method
    /// - Returns: The `URL?`.
    /// - Throws: The `GeneralError`.
    public func getFileThumbnailById(fileId: String, extension_: GetFileThumbnailByIdExtension, downloadDestinationUrl: URL, queryParams: GetFileThumbnailByIdQueryParams = GetFileThumbnailByIdQueryParams(), headers: GetFileThumbnailByIdHeaders = GetFileThumbnailByIdHeaders()) async throws -> URL? {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["min_height": Utils.Strings.toString(value: queryParams.minHeight), "min_width": Utils.Strings.toString(value: queryParams.minWidth), "max_height": Utils.Strings.toString(value: queryParams.maxHeight), "max_width": Utils.Strings.toString(value: queryParams.maxWidth)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/thumbnail.")\(extension_)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.binary, downloadDestinationUrl: downloadDestinationUrl, auth: self.auth, networkSession: self.networkSession))
        if Utils.Strings.toString(value: response.status) == "202" {
            return nil
        }

        return response.downloadDestinationUrl!
    }

}
