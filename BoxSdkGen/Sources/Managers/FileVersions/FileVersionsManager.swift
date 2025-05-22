import Foundation

public class FileVersionsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieve a list of the past versions for a file.
    /// 
    /// Versions are only tracked by Box users with premium accounts. To fetch the ID
    /// of the current version of a file, use the `GET /file/:id` API.
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
    ///   - queryParams: Query parameters of getFileVersions method
    ///   - headers: Headers of getFileVersions method
    /// - Returns: The `FileVersions`.
    /// - Throws: The `GeneralError`.
    public func getFileVersions(fileId: String, queryParams: GetFileVersionsQueryParams = GetFileVersionsQueryParams(), headers: GetFileVersionsHeaders = GetFileVersionsHeaders()) async throws -> FileVersions {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields), "limit": Utils.Strings.toString(value: queryParams.limit), "offset": Utils.Strings.toString(value: queryParams.offset)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/versions")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileVersions.deserialize(from: response.data!)
    }

    /// Retrieve a specific version of a file.
    /// 
    /// Versions are only tracked for Box users with premium accounts.
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
    ///   - fileVersionId: The ID of the file version
    ///     Example: "1234"
    ///   - queryParams: Query parameters of getFileVersionById method
    ///   - headers: Headers of getFileVersionById method
    /// - Returns: The `FileVersionFull`.
    /// - Throws: The `GeneralError`.
    public func getFileVersionById(fileId: String, fileVersionId: String, queryParams: GetFileVersionByIdQueryParams = GetFileVersionByIdQueryParams(), headers: GetFileVersionByIdHeaders = GetFileVersionByIdHeaders()) async throws -> FileVersionFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/versions/")\(fileVersionId)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileVersionFull.deserialize(from: response.data!)
    }

    /// Move a file version to the trash.
    /// 
    /// Versions are only tracked for Box users with premium accounts.
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
    ///   - fileVersionId: The ID of the file version
    ///     Example: "1234"
    ///   - headers: Headers of deleteFileVersionById method
    /// - Throws: The `GeneralError`.
    public func deleteFileVersionById(fileId: String, fileVersionId: String, headers: DeleteFileVersionByIdHeaders = DeleteFileVersionByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-match": Utils.Strings.toString(value: headers.ifMatch)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/versions/")\(fileVersionId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Restores a specific version of a file after it was deleted.
    /// Don't use this endpoint to restore Box Notes,
    /// as it works with file formats such as PDF, DOC,
    /// PPTX or similar.
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
    ///   - fileVersionId: The ID of the file version
    ///     Example: "1234"
    ///   - requestBody: Request body of updateFileVersionById method
    ///   - headers: Headers of updateFileVersionById method
    /// - Returns: The `FileVersionFull`.
    /// - Throws: The `GeneralError`.
    public func updateFileVersionById(fileId: String, fileVersionId: String, requestBody: UpdateFileVersionByIdRequestBody = UpdateFileVersionByIdRequestBody(), headers: UpdateFileVersionByIdHeaders = UpdateFileVersionByIdHeaders()) async throws -> FileVersionFull {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/versions/")\(fileVersionId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileVersionFull.deserialize(from: response.data!)
    }

    /// Promote a specific version of a file.
    /// 
    /// If previous versions exist, this method can be used to
    /// promote one of the older versions to the top of the version history.
    /// 
    /// This creates a new copy of the old version and puts it at the
    /// top of the versions history. The file will have the exact same contents
    /// as the older version, with the the same hash digest, `etag`, and
    /// name as the original.
    /// 
    /// Other properties such as comments do not get updated to their
    /// former values.
    /// 
    /// Don't use this endpoint to restore Box Notes,
    /// as it works with file formats such as PDF, DOC,
    /// PPTX or similar.
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
    ///   - requestBody: Request body of promoteFileVersion method
    ///   - queryParams: Query parameters of promoteFileVersion method
    ///   - headers: Headers of promoteFileVersion method
    /// - Returns: The `FileVersionFull`.
    /// - Throws: The `GeneralError`.
    public func promoteFileVersion(fileId: String, requestBody: PromoteFileVersionRequestBody = PromoteFileVersionRequestBody(), queryParams: PromoteFileVersionQueryParams = PromoteFileVersionQueryParams(), headers: PromoteFileVersionHeaders = PromoteFileVersionHeaders()) async throws -> FileVersionFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/versions/current")", method: "POST", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileVersionFull.deserialize(from: response.data!)
    }

}
