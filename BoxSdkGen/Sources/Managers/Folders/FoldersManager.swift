import Foundation

public class FoldersManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves details for a folder, including the first 100 entries
    /// in the folder.
    /// 
    /// Passing `sort`, `direction`, `offset`, and `limit`
    /// parameters in query allows you to manage the
    /// list of returned
    /// [folder items](r://folder--full#param-item-collection).
    /// 
    /// To fetch more items within the folder, use the
    /// [Get items in a folder](e://get-folders-id-items) endpoint.
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
    ///   - queryParams: Query parameters of getFolderById method
    ///   - headers: Headers of getFolderById method
    /// - Returns: The `FolderFull`.
    /// - Throws: The `GeneralError`.
    public func getFolderById(folderId: String, queryParams: GetFolderByIdQueryParams = GetFolderByIdQueryParams(), headers: GetFolderByIdHeaders = GetFolderByIdHeaders()) async throws -> FolderFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields), "sort": Utils.Strings.toString(value: queryParams.sort), "direction": Utils.Strings.toString(value: queryParams.direction), "offset": Utils.Strings.toString(value: queryParams.offset), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-none-match": Utils.Strings.toString(value: headers.ifNoneMatch), "boxapi": Utils.Strings.toString(value: headers.boxapi)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FolderFull.deserialize(from: response.data!)
    }

    /// Updates a folder. This can be also be used to move the folder,
    /// create shared links, update collaborations, and more.
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
    ///   - requestBody: Request body of updateFolderById method
    ///   - queryParams: Query parameters of updateFolderById method
    ///   - headers: Headers of updateFolderById method
    /// - Returns: The `FolderFull`.
    /// - Throws: The `GeneralError`.
    public func updateFolderById(folderId: String, requestBody: UpdateFolderByIdRequestBody = UpdateFolderByIdRequestBody(), queryParams: UpdateFolderByIdQueryParams = UpdateFolderByIdQueryParams(), headers: UpdateFolderByIdHeaders = UpdateFolderByIdHeaders()) async throws -> FolderFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-match": Utils.Strings.toString(value: headers.ifMatch)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FolderFull.deserialize(from: response.data!)
    }

    /// Deletes a folder, either permanently or by moving it to
    /// the trash.
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
    ///   - queryParams: Query parameters of deleteFolderById method
    ///   - headers: Headers of deleteFolderById method
    /// - Throws: The `GeneralError`.
    public func deleteFolderById(folderId: String, queryParams: DeleteFolderByIdQueryParams = DeleteFolderByIdQueryParams(), headers: DeleteFolderByIdHeaders = DeleteFolderByIdHeaders()) async throws {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["recursive": Utils.Strings.toString(value: queryParams.recursive)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-match": Utils.Strings.toString(value: headers.ifMatch)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)", method: "DELETE", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Retrieves a page of items in a folder. These items can be files,
    /// folders, and web links.
    /// 
    /// To request more information about the folder itself, like its size,
    /// use the [Get a folder](#get-folders-id) endpoint instead.
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
    ///   - queryParams: Query parameters of getFolderItems method
    ///   - headers: Headers of getFolderItems method
    /// - Returns: The `Items`.
    /// - Throws: The `GeneralError`.
    public func getFolderItems(folderId: String, queryParams: GetFolderItemsQueryParams = GetFolderItemsQueryParams(), headers: GetFolderItemsHeaders = GetFolderItemsHeaders()) async throws -> Items {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields), "usemarker": Utils.Strings.toString(value: queryParams.usemarker), "marker": Utils.Strings.toString(value: queryParams.marker), "offset": Utils.Strings.toString(value: queryParams.offset), "limit": Utils.Strings.toString(value: queryParams.limit), "sort": Utils.Strings.toString(value: queryParams.sort), "direction": Utils.Strings.toString(value: queryParams.direction)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["boxapi": Utils.Strings.toString(value: headers.boxapi)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/items")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Items.deserialize(from: response.data!)
    }

    /// Creates a new empty folder within the specified parent folder.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createFolder method
    ///   - queryParams: Query parameters of createFolder method
    ///   - headers: Headers of createFolder method
    /// - Returns: The `FolderFull`.
    /// - Throws: The `GeneralError`.
    public func createFolder(requestBody: CreateFolderRequestBody, queryParams: CreateFolderQueryParams = CreateFolderQueryParams(), headers: CreateFolderHeaders = CreateFolderHeaders()) async throws -> FolderFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders")", method: "POST", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FolderFull.deserialize(from: response.data!)
    }

    /// Creates a copy of a folder within a destination folder.
    /// 
    /// The original folder will not be changed.
    ///
    /// - Parameters:
    ///   - folderId: The unique identifier of the folder to copy.
    ///     
    ///     The ID for any folder can be determined
    ///     by visiting this folder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/folder/123`
    ///     the `folder_id` is `123`.
    ///     
    ///     The root folder with the ID `0` can not be copied.
    ///     Example: "0"
    ///   - requestBody: Request body of copyFolder method
    ///   - queryParams: Query parameters of copyFolder method
    ///   - headers: Headers of copyFolder method
    /// - Returns: The `FolderFull`.
    /// - Throws: The `GeneralError`.
    public func copyFolder(folderId: String, requestBody: CopyFolderRequestBody, queryParams: CopyFolderQueryParams = CopyFolderQueryParams(), headers: CopyFolderHeaders = CopyFolderHeaders()) async throws -> FolderFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/copy")", method: "POST", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FolderFull.deserialize(from: response.data!)
    }

}
