import Foundation

public class AppItemAssociationsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// **This is a beta feature, which means that its availability might be limited.**
    /// Returns all app items the file is associated with. This includes app items
    /// associated with ancestors of the file. Assuming the context user has access
    /// to the file, the type/ids are revealed even if the context user does not
    /// have **View** permission on the app item.
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
    ///   - queryParams: Query parameters of getFileAppItemAssociations method
    ///   - headers: Headers of getFileAppItemAssociations method
    /// - Returns: The `AppItemAssociations`.
    /// - Throws: The `GeneralError`.
    public func getFileAppItemAssociations(fileId: String, queryParams: GetFileAppItemAssociationsQueryParams = GetFileAppItemAssociationsQueryParams(), headers: GetFileAppItemAssociationsHeaders = GetFileAppItemAssociationsHeaders()) async throws -> AppItemAssociations {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["limit": Utils.Strings.toString(value: queryParams.limit), "marker": Utils.Strings.toString(value: queryParams.marker), "application_type": Utils.Strings.toString(value: queryParams.applicationType)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/app_item_associations")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AppItemAssociations.deserialize(from: response.data!)
    }

    /// **This is a beta feature, which means that its availability might be limited.**
    /// Returns all app items the folder is associated with. This includes app items
    /// associated with ancestors of the folder. Assuming the context user has access
    /// to the folder, the type/ids are revealed even if the context user does not
    /// have **View** permission on the app item.
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
    ///   - queryParams: Query parameters of getFolderAppItemAssociations method
    ///   - headers: Headers of getFolderAppItemAssociations method
    /// - Returns: The `AppItemAssociations`.
    /// - Throws: The `GeneralError`.
    public func getFolderAppItemAssociations(folderId: String, queryParams: GetFolderAppItemAssociationsQueryParams = GetFolderAppItemAssociationsQueryParams(), headers: GetFolderAppItemAssociationsHeaders = GetFolderAppItemAssociationsHeaders()) async throws -> AppItemAssociations {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["limit": Utils.Strings.toString(value: queryParams.limit), "marker": Utils.Strings.toString(value: queryParams.marker), "application_type": Utils.Strings.toString(value: queryParams.applicationType)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/app_item_associations")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AppItemAssociations.deserialize(from: response.data!)
    }

}
