import Foundation

public class FolderWatermarksManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieve the watermark for a folder.
    ///
    /// - Parameters:
    ///   - folderId: The unique identifier that represent a folder.
    ///     
    ///     The ID for any folder can be determined
    ///     by visiting this folder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/folder/123`
    ///     the `folder_id` is `123`.
    ///     
    ///     The root folder of a Box account is
    ///     always represented by the ID `0`.
    ///     Example: "12345"
    ///   - headers: Headers of getFolderWatermark method
    /// - Returns: The `Watermark`.
    /// - Throws: The `GeneralError`.
    public func getFolderWatermark(folderId: String, headers: GetFolderWatermarkHeaders = GetFolderWatermarkHeaders()) async throws -> Watermark {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/watermark")", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Watermark.deserialize(from: response.data!)
    }

    /// Applies or update a watermark on a folder.
    ///
    /// - Parameters:
    ///   - folderId: The unique identifier that represent a folder.
    ///     
    ///     The ID for any folder can be determined
    ///     by visiting this folder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/folder/123`
    ///     the `folder_id` is `123`.
    ///     
    ///     The root folder of a Box account is
    ///     always represented by the ID `0`.
    ///     Example: "12345"
    ///   - requestBody: Request body of updateFolderWatermark method
    ///   - headers: Headers of updateFolderWatermark method
    /// - Returns: The `Watermark`.
    /// - Throws: The `GeneralError`.
    public func updateFolderWatermark(folderId: String, requestBody: UpdateFolderWatermarkRequestBody, headers: UpdateFolderWatermarkHeaders = UpdateFolderWatermarkHeaders()) async throws -> Watermark {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/watermark")", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Watermark.deserialize(from: response.data!)
    }

    /// Removes the watermark from a folder.
    ///
    /// - Parameters:
    ///   - folderId: The unique identifier that represent a folder.
    ///     
    ///     The ID for any folder can be determined
    ///     by visiting this folder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/folder/123`
    ///     the `folder_id` is `123`.
    ///     
    ///     The root folder of a Box account is
    ///     always represented by the ID `0`.
    ///     Example: "12345"
    ///   - headers: Headers of deleteFolderWatermark method
    /// - Throws: The `GeneralError`.
    public func deleteFolderWatermark(folderId: String, headers: DeleteFolderWatermarkHeaders = DeleteFolderWatermarkHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/watermark")", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
