import Foundation

public class ListCollaborationsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves a list of pending and active collaborations for a
    /// file. This returns all the users that have access to the file
    /// or have been invited to the file.
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
    ///   - queryParams: Query parameters of getFileCollaborations method
    ///   - headers: Headers of getFileCollaborations method
    /// - Returns: The `Collaborations`.
    /// - Throws: The `GeneralError`.
    public func getFileCollaborations(fileId: String, queryParams: GetFileCollaborationsQueryParams = GetFileCollaborationsQueryParams(), headers: GetFileCollaborationsHeaders = GetFileCollaborationsHeaders()) async throws -> Collaborations {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields), "limit": Utils.Strings.toString(value: queryParams.limit), "marker": Utils.Strings.toString(value: queryParams.marker)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/collaborations")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Collaborations.deserialize(from: response.data!)
    }

    /// Retrieves a list of pending and active collaborations for a
    /// folder. This returns all the users that have access to the folder
    /// or have been invited to the folder.
    ///
    /// - Parameters:
    ///   - folderId: The unique identifier that represent a folder.
    ///     
    ///     The ID for any folder can be determined
    ///     by visiting this folder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/folder/123`
    ///     the `folder_id` is `123`.
    ///     Example: "12345"
    ///   - queryParams: Query parameters of getFolderCollaborations method
    ///   - headers: Headers of getFolderCollaborations method
    /// - Returns: The `Collaborations`.
    /// - Throws: The `GeneralError`.
    public func getFolderCollaborations(folderId: String, queryParams: GetFolderCollaborationsQueryParams = GetFolderCollaborationsQueryParams(), headers: GetFolderCollaborationsHeaders = GetFolderCollaborationsHeaders()) async throws -> Collaborations {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields), "limit": Utils.Strings.toString(value: queryParams.limit), "marker": Utils.Strings.toString(value: queryParams.marker)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/collaborations")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Collaborations.deserialize(from: response.data!)
    }

    /// Retrieves all pending collaboration invites for this user.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getCollaborations method
    ///   - headers: Headers of getCollaborations method
    /// - Returns: The `CollaborationsOffsetPaginated`.
    /// - Throws: The `GeneralError`.
    public func getCollaborations(queryParams: GetCollaborationsQueryParams, headers: GetCollaborationsHeaders = GetCollaborationsHeaders()) async throws -> CollaborationsOffsetPaginated {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["status": Utils.Strings.toString(value: queryParams.status), "fields": Utils.Strings.toString(value: queryParams.fields), "offset": Utils.Strings.toString(value: queryParams.offset), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaborations")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try CollaborationsOffsetPaginated.deserialize(from: response.data!)
    }

    /// Retrieves all the collaborations for a group. The user
    /// must have admin permissions to inspect enterprise's groups.
    /// 
    /// Each collaboration object has details on which files or
    /// folders the group has access to and with what role.
    ///
    /// - Parameters:
    ///   - groupId: The ID of the group.
    ///     Example: "57645"
    ///   - queryParams: Query parameters of getGroupCollaborations method
    ///   - headers: Headers of getGroupCollaborations method
    /// - Returns: The `CollaborationsOffsetPaginated`.
    /// - Throws: The `GeneralError`.
    public func getGroupCollaborations(groupId: String, queryParams: GetGroupCollaborationsQueryParams = GetGroupCollaborationsQueryParams(), headers: GetGroupCollaborationsHeaders = GetGroupCollaborationsHeaders()) async throws -> CollaborationsOffsetPaginated {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["limit": Utils.Strings.toString(value: queryParams.limit), "offset": Utils.Strings.toString(value: queryParams.offset)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/groups/")\(groupId)\("/collaborations")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try CollaborationsOffsetPaginated.deserialize(from: response.data!)
    }

}
