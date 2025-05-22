import Foundation

public class FileMetadataManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves all metadata for a given file.
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
    ///   - headers: Headers of getFileMetadata method
    /// - Returns: The `Metadatas`.
    /// - Throws: The `GeneralError`.
    public func getFileMetadata(fileId: String, headers: GetFileMetadataHeaders = GetFileMetadataHeaders()) async throws -> Metadatas {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata")", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Metadatas.deserialize(from: response.data!)
    }

    /// Retrieves the instance of a metadata template that has been applied to a
    /// file.
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
    ///   - scope: The scope of the metadata template
    ///     Example: "global"
    ///   - templateKey: The name of the metadata template
    ///     Example: "properties"
    ///   - headers: Headers of getFileMetadataById method
    /// - Returns: The `MetadataFull`.
    /// - Throws: The `GeneralError`.
    public func getFileMetadataById(fileId: String, scope: GetFileMetadataByIdScope, templateKey: String, headers: GetFileMetadataByIdHeaders = GetFileMetadataByIdHeaders()) async throws -> MetadataFull {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/")\(scope)\("/")\(templateKey)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataFull.deserialize(from: response.data!)
    }

    /// Applies an instance of a metadata template to a file.
    /// 
    /// In most cases only values that are present in the metadata template
    /// will be accepted, except for the `global.properties` template which accepts
    /// any key-value pair.
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
    ///   - scope: The scope of the metadata template
    ///     Example: "global"
    ///   - templateKey: The name of the metadata template
    ///     Example: "properties"
    ///   - requestBody: Request body of createFileMetadataById method
    ///   - headers: Headers of createFileMetadataById method
    /// - Returns: The `MetadataFull`.
    /// - Throws: The `GeneralError`.
    public func createFileMetadataById(fileId: String, scope: CreateFileMetadataByIdScope, templateKey: String, requestBody: CreateFileMetadataByIdRequestBody, headers: CreateFileMetadataByIdHeaders = CreateFileMetadataByIdHeaders()) async throws -> MetadataFull {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/")\(scope)\("/")\(templateKey)", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataFull.deserialize(from: response.data!)
    }

    /// Updates a piece of metadata on a file.
    /// 
    /// The metadata instance can only be updated if the template has already been
    /// applied to the file before. When editing metadata, only values that match
    /// the metadata template schema will be accepted.
    /// 
    /// The update is applied atomically. If any errors occur during the
    /// application of the operations, the metadata instance will not be changed.
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
    ///   - scope: The scope of the metadata template
    ///     Example: "global"
    ///   - templateKey: The name of the metadata template
    ///     Example: "properties"
    ///   - requestBody: Request body of updateFileMetadataById method
    ///   - headers: Headers of updateFileMetadataById method
    /// - Returns: The `MetadataFull`.
    /// - Throws: The `GeneralError`.
    public func updateFileMetadataById(fileId: String, scope: UpdateFileMetadataByIdScope, templateKey: String, requestBody: [UpdateFileMetadataByIdRequestBody], headers: UpdateFileMetadataByIdHeaders = UpdateFileMetadataByIdHeaders()) async throws -> MetadataFull {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/")\(scope)\("/")\(templateKey)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json-patch+json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataFull.deserialize(from: response.data!)
    }

    /// Deletes a piece of file metadata.
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
    ///   - scope: The scope of the metadata template
    ///     Example: "global"
    ///   - templateKey: The name of the metadata template
    ///     Example: "properties"
    ///   - headers: Headers of deleteFileMetadataById method
    /// - Throws: The `GeneralError`.
    public func deleteFileMetadataById(fileId: String, scope: DeleteFileMetadataByIdScope, templateKey: String, headers: DeleteFileMetadataByIdHeaders = DeleteFileMetadataByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/")\(scope)\("/")\(templateKey)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
