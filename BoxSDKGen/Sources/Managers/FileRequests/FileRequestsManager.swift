import Foundation

public class FileRequestsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves the information about a file request.
    ///
    /// - Parameters:
    ///   - fileRequestId: The unique identifier that represent a file request.
    ///     
    ///     The ID for any file request can be determined
    ///     by visiting a file request builder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/filerequest/123`
    ///     the `file_request_id` is `123`.
    ///     Example: "123"
    ///   - headers: Headers of getFileRequestById method
    /// - Returns: The `FileRequest`.
    /// - Throws: The `GeneralError`.
    public func getFileRequestById(fileRequestId: String, headers: GetFileRequestByIdHeaders = GetFileRequestByIdHeaders()) async throws -> FileRequest {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/file_requests/")\(fileRequestId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileRequest.deserialize(from: response.data!)
    }

    /// Updates a file request. This can be used to activate or
    /// deactivate a file request.
    ///
    /// - Parameters:
    ///   - fileRequestId: The unique identifier that represent a file request.
    ///     
    ///     The ID for any file request can be determined
    ///     by visiting a file request builder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/filerequest/123`
    ///     the `file_request_id` is `123`.
    ///     Example: "123"
    ///   - requestBody: Request body of updateFileRequestById method
    ///   - headers: Headers of updateFileRequestById method
    /// - Returns: The `FileRequest`.
    /// - Throws: The `GeneralError`.
    public func updateFileRequestById(fileRequestId: String, requestBody: FileRequestUpdateRequest, headers: UpdateFileRequestByIdHeaders = UpdateFileRequestByIdHeaders()) async throws -> FileRequest {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-match": Utils.Strings.toString(value: headers.ifMatch)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/file_requests/")\(fileRequestId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileRequest.deserialize(from: response.data!)
    }

    /// Deletes a file request permanently.
    ///
    /// - Parameters:
    ///   - fileRequestId: The unique identifier that represent a file request.
    ///     
    ///     The ID for any file request can be determined
    ///     by visiting a file request builder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/filerequest/123`
    ///     the `file_request_id` is `123`.
    ///     Example: "123"
    ///   - headers: Headers of deleteFileRequestById method
    /// - Throws: The `GeneralError`.
    public func deleteFileRequestById(fileRequestId: String, headers: DeleteFileRequestByIdHeaders = DeleteFileRequestByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/file_requests/")\(fileRequestId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Copies an existing file request that is already present on one folder,
    /// and applies it to another folder.
    ///
    /// - Parameters:
    ///   - fileRequestId: The unique identifier that represent a file request.
    ///     
    ///     The ID for any file request can be determined
    ///     by visiting a file request builder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/filerequest/123`
    ///     the `file_request_id` is `123`.
    ///     Example: "123"
    ///   - requestBody: Request body of createFileRequestCopy method
    ///   - headers: Headers of createFileRequestCopy method
    /// - Returns: The `FileRequest`.
    /// - Throws: The `GeneralError`.
    public func createFileRequestCopy(fileRequestId: String, requestBody: FileRequestCopyRequest, headers: CreateFileRequestCopyHeaders = CreateFileRequestCopyHeaders()) async throws -> FileRequest {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/file_requests/")\(fileRequestId)\("/copy")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileRequest.deserialize(from: response.data!)
    }

}
