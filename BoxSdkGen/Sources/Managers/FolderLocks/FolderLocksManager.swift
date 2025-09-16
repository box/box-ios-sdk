import Foundation

public class FolderLocksManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves folder lock details for a given folder.
    /// 
    /// You must be authenticated as the owner or co-owner of the folder to
    /// use this endpoint.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getFolderLocks method
    ///   - headers: Headers of getFolderLocks method
    /// - Returns: The `FolderLocks`.
    /// - Throws: The `GeneralError`.
    public func getFolderLocks(queryParams: GetFolderLocksQueryParams, headers: GetFolderLocksHeaders = GetFolderLocksHeaders()) async throws -> FolderLocks {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["folder_id": Utils.Strings.toString(value: queryParams.folderId)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folder_locks")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FolderLocks.deserialize(from: response.data!)
    }

    /// Creates a folder lock on a folder, preventing it from being moved and/or
    /// deleted.
    /// 
    /// You must be authenticated as the owner or co-owner of the folder to
    /// use this endpoint.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createFolderLock method
    ///   - headers: Headers of createFolderLock method
    /// - Returns: The `FolderLock`.
    /// - Throws: The `GeneralError`.
    public func createFolderLock(requestBody: CreateFolderLockRequestBody, headers: CreateFolderLockHeaders = CreateFolderLockHeaders()) async throws -> FolderLock {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folder_locks")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FolderLock.deserialize(from: response.data!)
    }

    /// Deletes a folder lock on a given folder.
    /// 
    /// You must be authenticated as the owner or co-owner of the folder to
    /// use this endpoint.
    ///
    /// - Parameters:
    ///   - folderLockId: The ID of the folder lock.
    ///     Example: "12345"
    ///   - headers: Headers of deleteFolderLockById method
    /// - Throws: The `GeneralError`.
    public func deleteFolderLockById(folderLockId: String, headers: DeleteFolderLockByIdHeaders = DeleteFolderLockByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folder_locks/")\(folderLockId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
