import Foundation

public class FolderClassificationsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves the classification metadata instance that
    /// has been applied to a folder.
    /// 
    /// This API can also be called by including the enterprise ID in the
    /// URL explicitly, for example
    /// `/folders/:id/enterprise_12345/securityClassification-6VMVochwUWo`.
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
    ///   - headers: Headers of getClassificationOnFolder method
    /// - Returns: The `Classification`.
    /// - Throws: The `GeneralError`.
    public func getClassificationOnFolder(folderId: String, headers: GetClassificationOnFolderHeaders = GetClassificationOnFolderHeaders()) async throws -> Classification {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/metadata/enterprise/securityClassification-6VMVochwUWo")", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Classification.deserialize(from: response.data!)
    }

    /// Adds a classification to a folder by specifying the label of the
    /// classification to add.
    /// 
    /// This API can also be called by including the enterprise ID in the
    /// URL explicitly, for example
    /// `/folders/:id/enterprise_12345/securityClassification-6VMVochwUWo`.
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
    ///   - requestBody: Request body of addClassificationToFolder method
    ///   - headers: Headers of addClassificationToFolder method
    /// - Returns: The `Classification`.
    /// - Throws: The `GeneralError`.
    public func addClassificationToFolder(folderId: String, requestBody: AddClassificationToFolderRequestBody = AddClassificationToFolderRequestBody(), headers: AddClassificationToFolderHeaders = AddClassificationToFolderHeaders()) async throws -> Classification {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/metadata/enterprise/securityClassification-6VMVochwUWo")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Classification.deserialize(from: response.data!)
    }

    /// Updates a classification on a folder.
    /// 
    /// The classification can only be updated if a classification has already been
    /// applied to the folder before. When editing classifications, only values are
    /// defined for the enterprise will be accepted.
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
    ///   - requestBody: Request body of updateClassificationOnFolder method
    ///   - headers: Headers of updateClassificationOnFolder method
    /// - Returns: The `Classification`.
    /// - Throws: The `GeneralError`.
    public func updateClassificationOnFolder(folderId: String, requestBody: [UpdateClassificationOnFolderRequestBody], headers: UpdateClassificationOnFolderHeaders = UpdateClassificationOnFolderHeaders()) async throws -> Classification {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/metadata/enterprise/securityClassification-6VMVochwUWo")", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json-patch+json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Classification.deserialize(from: response.data!)
    }

    /// Removes any classifications from a folder.
    /// 
    /// This API can also be called by including the enterprise ID in the
    /// URL explicitly, for example
    /// `/folders/:id/enterprise_12345/securityClassification-6VMVochwUWo`.
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
    ///   - headers: Headers of deleteClassificationFromFolder method
    /// - Throws: The `GeneralError`.
    public func deleteClassificationFromFolder(folderId: String, headers: DeleteClassificationFromFolderHeaders = DeleteClassificationFromFolderHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/folders/")\(folderId)\("/metadata/enterprise/securityClassification-6VMVochwUWo")", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
