import Foundation

public class SharedLinksFoldersManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Return the folder represented by a shared link.
    /// 
    /// A shared folder can be represented by a shared link,
    /// which can originate within the current enterprise or within another.
    /// 
    /// This endpoint allows an application to retrieve information about a
    /// shared folder when only given a shared link.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of findFolderForSharedLink method
    ///   - headers: Headers of findFolderForSharedLink method
    /// - Returns: The `FolderFull`.
    /// - Throws: The `GeneralError`.
    public func findFolderForSharedLink(queryParams: FindFolderForSharedLinkQueryParams = FindFolderForSharedLinkQueryParams(), headers: FindFolderForSharedLinkHeaders) async throws -> FolderFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-none-match": Utils.Strings.toString(value: headers.ifNoneMatch), "boxapi": Utils.Strings.toString(value: headers.boxapi)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shared_items#folders")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FolderFull.deserialize(from: response.data!)
    }

    /// Gets the information for a shared link on a folder.
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
    ///   - queryParams: Query parameters of getSharedLinkForFolder method
    ///   - headers: Headers of getSharedLinkForFolder method
    /// - Returns: The `FolderFull`.
    /// - Throws: The `GeneralError`.
    public func getSharedLinkForFolder(folderId: String, queryParams: GetSharedLinkForFolderQueryParams, headers: GetSharedLinkForFolderHeaders = GetSharedLinkForFolderHeaders()) async throws -> FolderFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("#get_shared_link")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FolderFull.deserialize(from: response.data!)
    }

    /// Adds a shared link to a folder.
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
    ///   - requestBody: Request body of addShareLinkToFolder method
    ///   - queryParams: Query parameters of addShareLinkToFolder method
    ///   - headers: Headers of addShareLinkToFolder method
    /// - Returns: The `FolderFull`.
    /// - Throws: The `GeneralError`.
    public func addShareLinkToFolder(folderId: String, requestBody: AddShareLinkToFolderRequestBody = AddShareLinkToFolderRequestBody(), queryParams: AddShareLinkToFolderQueryParams, headers: AddShareLinkToFolderHeaders = AddShareLinkToFolderHeaders()) async throws -> FolderFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("#add_shared_link")", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FolderFull.deserialize(from: response.data!)
    }

    /// Updates a shared link on a folder.
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
    ///   - requestBody: Request body of updateSharedLinkOnFolder method
    ///   - queryParams: Query parameters of updateSharedLinkOnFolder method
    ///   - headers: Headers of updateSharedLinkOnFolder method
    /// - Returns: The `FolderFull`.
    /// - Throws: The `GeneralError`.
    public func updateSharedLinkOnFolder(folderId: String, requestBody: UpdateSharedLinkOnFolderRequestBody = UpdateSharedLinkOnFolderRequestBody(), queryParams: UpdateSharedLinkOnFolderQueryParams, headers: UpdateSharedLinkOnFolderHeaders = UpdateSharedLinkOnFolderHeaders()) async throws -> FolderFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("#update_shared_link")", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FolderFull.deserialize(from: response.data!)
    }

    /// Removes a shared link from a folder.
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
    ///   - requestBody: Request body of removeSharedLinkFromFolder method
    ///   - queryParams: Query parameters of removeSharedLinkFromFolder method
    ///   - headers: Headers of removeSharedLinkFromFolder method
    /// - Returns: The `FolderFull`.
    /// - Throws: The `GeneralError`.
    public func removeSharedLinkFromFolder(folderId: String, requestBody: RemoveSharedLinkFromFolderRequestBody = RemoveSharedLinkFromFolderRequestBody(), queryParams: RemoveSharedLinkFromFolderQueryParams, headers: RemoveSharedLinkFromFolderHeaders = RemoveSharedLinkFromFolderHeaders()) async throws -> FolderFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("#remove_shared_link")", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FolderFull.deserialize(from: response.data!)
    }

}
