import Foundation

public class FileClassificationsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves the classification metadata instance that
    /// has been applied to a file.
    /// 
    /// This API can also be called by including the enterprise ID in the
    /// URL explicitly, for example
    /// `/files/:id//enterprise_12345/securityClassification-6VMVochwUWo`.
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
    ///   - headers: Headers of getClassificationOnFile method
    /// - Returns: The `Classification`.
    /// - Throws: The `GeneralError`.
    public func getClassificationOnFile(fileId: String, headers: GetClassificationOnFileHeaders = GetClassificationOnFileHeaders()) async throws -> Classification {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/enterprise/securityClassification-6VMVochwUWo")", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Classification.deserialize(from: response.data!)
    }

    /// Adds a classification to a file by specifying the label of the
    /// classification to add.
    /// 
    /// This API can also be called by including the enterprise ID in the
    /// URL explicitly, for example
    /// `/files/:id//enterprise_12345/securityClassification-6VMVochwUWo`.
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
    ///   - requestBody: Request body of addClassificationToFile method
    ///   - headers: Headers of addClassificationToFile method
    /// - Returns: The `Classification`.
    /// - Throws: The `GeneralError`.
    public func addClassificationToFile(fileId: String, requestBody: AddClassificationToFileRequestBody = AddClassificationToFileRequestBody(), headers: AddClassificationToFileHeaders = AddClassificationToFileHeaders()) async throws -> Classification {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/enterprise/securityClassification-6VMVochwUWo")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Classification.deserialize(from: response.data!)
    }

    /// Updates a classification on a file.
    /// 
    /// The classification can only be updated if a classification has already been
    /// applied to the file before. When editing classifications, only values are
    /// defined for the enterprise will be accepted.
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
    ///   - requestBody: Request body of updateClassificationOnFile method
    ///   - headers: Headers of updateClassificationOnFile method
    /// - Returns: The `Classification`.
    /// - Throws: The `GeneralError`.
    public func updateClassificationOnFile(fileId: String, requestBody: [UpdateClassificationOnFileRequestBody], headers: UpdateClassificationOnFileHeaders = UpdateClassificationOnFileHeaders()) async throws -> Classification {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/enterprise/securityClassification-6VMVochwUWo")", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json-patch+json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Classification.deserialize(from: response.data!)
    }

    /// Removes any classifications from a file.
    /// 
    /// This API can also be called by including the enterprise ID in the
    /// URL explicitly, for example
    /// `/files/:id//enterprise_12345/securityClassification-6VMVochwUWo`.
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
    ///   - headers: Headers of deleteClassificationFromFile method
    /// - Throws: The `GeneralError`.
    public func deleteClassificationFromFile(fileId: String, headers: DeleteClassificationFromFileHeaders = DeleteClassificationFromFileHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/enterprise/securityClassification-6VMVochwUWo")", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
