import Foundation

public class SharedLinksFilesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns the file represented by a shared link.
    /// 
    /// A shared file can be represented by a shared link,
    /// which can originate within the current enterprise or within another.
    /// 
    /// This endpoint allows an application to retrieve information about a
    /// shared file when only given a shared link.
    /// 
    /// The `shared_link_permission_options` array field can be returned
    /// by requesting it in the `fields` query parameter.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of findFileForSharedLink method
    ///   - headers: Headers of findFileForSharedLink method
    /// - Returns: The `FileFull`.
    /// - Throws: The `GeneralError`.
    public func findFileForSharedLink(queryParams: FindFileForSharedLinkQueryParams = FindFileForSharedLinkQueryParams(), headers: FindFileForSharedLinkHeaders) async throws -> FileFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-none-match": Utils.Strings.toString(value: headers.ifNoneMatch), "boxapi": Utils.Strings.toString(value: headers.boxapi)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shared_items")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileFull.deserialize(from: response.data!)
    }

    /// Gets the information for a shared link on a file.
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
    ///   - queryParams: Query parameters of getSharedLinkForFile method
    ///   - headers: Headers of getSharedLinkForFile method
    /// - Returns: The `FileFull`.
    /// - Throws: The `GeneralError`.
    public func getSharedLinkForFile(fileId: String, queryParams: GetSharedLinkForFileQueryParams, headers: GetSharedLinkForFileHeaders = GetSharedLinkForFileHeaders()) async throws -> FileFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("#get_shared_link")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileFull.deserialize(from: response.data!)
    }

    /// Adds a shared link to a file.
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
    ///   - requestBody: Request body of addShareLinkToFile method
    ///   - queryParams: Query parameters of addShareLinkToFile method
    ///   - headers: Headers of addShareLinkToFile method
    /// - Returns: The `FileFull`.
    /// - Throws: The `GeneralError`.
    public func addShareLinkToFile(fileId: String, requestBody: AddShareLinkToFileRequestBody = AddShareLinkToFileRequestBody(), queryParams: AddShareLinkToFileQueryParams, headers: AddShareLinkToFileHeaders = AddShareLinkToFileHeaders()) async throws -> FileFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("#add_shared_link")", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileFull.deserialize(from: response.data!)
    }

    /// Updates a shared link on a file.
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
    ///   - requestBody: Request body of updateSharedLinkOnFile method
    ///   - queryParams: Query parameters of updateSharedLinkOnFile method
    ///   - headers: Headers of updateSharedLinkOnFile method
    /// - Returns: The `FileFull`.
    /// - Throws: The `GeneralError`.
    public func updateSharedLinkOnFile(fileId: String, requestBody: UpdateSharedLinkOnFileRequestBody = UpdateSharedLinkOnFileRequestBody(), queryParams: UpdateSharedLinkOnFileQueryParams, headers: UpdateSharedLinkOnFileHeaders = UpdateSharedLinkOnFileHeaders()) async throws -> FileFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("#update_shared_link")", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileFull.deserialize(from: response.data!)
    }

    /// Removes a shared link from a file.
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
    ///   - requestBody: Request body of removeSharedLinkFromFile method
    ///   - queryParams: Query parameters of removeSharedLinkFromFile method
    ///   - headers: Headers of removeSharedLinkFromFile method
    /// - Returns: The `FileFull`.
    /// - Throws: The `GeneralError`.
    public func removeSharedLinkFromFile(fileId: String, requestBody: RemoveSharedLinkFromFileRequestBody = RemoveSharedLinkFromFileRequestBody(), queryParams: RemoveSharedLinkFromFileQueryParams, headers: RemoveSharedLinkFromFileHeaders = RemoveSharedLinkFromFileHeaders()) async throws -> FileFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("#remove_shared_link")", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileFull.deserialize(from: response.data!)
    }

}
