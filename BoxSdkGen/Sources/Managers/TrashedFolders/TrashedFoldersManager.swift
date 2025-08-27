import Foundation

public class TrashedFoldersManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Restores a folder that has been moved to the trash.
    /// 
    /// An optional new parent ID can be provided to restore the folder to in case the
    /// original folder has been deleted.
    /// 
    /// During this operation, part of the file tree will be locked, mainly
    /// the source folder and all of its descendants, as well as the destination
    /// folder.
    /// 
    /// For the duration of the operation, no other move, copy, delete, or restore
    /// operation can performed on any of the locked folders.
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
    ///   - requestBody: Request body of restoreFolderFromTrash method
    ///   - queryParams: Query parameters of restoreFolderFromTrash method
    ///   - headers: Headers of restoreFolderFromTrash method
    /// - Returns: The `TrashFolderRestored`.
    /// - Throws: The `GeneralError`.
    public func restoreFolderFromTrash(folderId: String, requestBody: RestoreFolderFromTrashRequestBody = RestoreFolderFromTrashRequestBody(), queryParams: RestoreFolderFromTrashQueryParams = RestoreFolderFromTrashQueryParams(), headers: RestoreFolderFromTrashHeaders = RestoreFolderFromTrashHeaders()) async throws -> TrashFolderRestored {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)", method: "POST", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TrashFolderRestored.deserialize(from: response.data!)
    }

    /// Retrieves a folder that has been moved to the trash.
    /// 
    /// Please note that only if the folder itself has been moved to the
    /// trash can it be retrieved with this API call. If instead one of
    /// its parent folders was moved to the trash, only that folder
    /// can be inspected using the
    /// [`GET /folders/:id/trash`](e://get_folders_id_trash) API.
    /// 
    /// To list all items that have been moved to the trash, please
    /// use the [`GET /folders/trash/items`](e://get-folders-trash-items/)
    /// API.
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
    ///   - queryParams: Query parameters of getTrashedFolderById method
    ///   - headers: Headers of getTrashedFolderById method
    /// - Returns: The `TrashFolder`.
    /// - Throws: The `GeneralError`.
    public func getTrashedFolderById(folderId: String, queryParams: GetTrashedFolderByIdQueryParams = GetTrashedFolderByIdQueryParams(), headers: GetTrashedFolderByIdHeaders = GetTrashedFolderByIdHeaders()) async throws -> TrashFolder {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/trash")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TrashFolder.deserialize(from: response.data!)
    }

    /// Permanently deletes a folder that is in the trash.
    /// This action cannot be undone.
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
    ///   - headers: Headers of deleteTrashedFolderById method
    /// - Throws: The `GeneralError`.
    public func deleteTrashedFolderById(folderId: String, headers: DeleteTrashedFolderByIdHeaders = DeleteTrashedFolderByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/trash")", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
