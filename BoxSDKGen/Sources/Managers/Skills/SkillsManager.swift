import Foundation

public class SkillsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// List the Box Skills metadata cards that are attached to a file.
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
    ///   - headers: Headers of getBoxSkillCardsOnFile method
    /// - Returns: The `SkillCardsMetadata`.
    /// - Throws: The `GeneralError`.
    public func getBoxSkillCardsOnFile(fileId: String, headers: GetBoxSkillCardsOnFileHeaders = GetBoxSkillCardsOnFileHeaders()) async throws -> SkillCardsMetadata {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/global/boxSkillsCards")", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try SkillCardsMetadata.deserialize(from: response.data!)
    }

    /// Applies one or more Box Skills metadata cards to a file.
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
    ///   - requestBody: Request body of createBoxSkillCardsOnFile method
    ///   - headers: Headers of createBoxSkillCardsOnFile method
    /// - Returns: The `SkillCardsMetadata`.
    /// - Throws: The `GeneralError`.
    public func createBoxSkillCardsOnFile(fileId: String, requestBody: CreateBoxSkillCardsOnFileRequestBody, headers: CreateBoxSkillCardsOnFileHeaders = CreateBoxSkillCardsOnFileHeaders()) async throws -> SkillCardsMetadata {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/global/boxSkillsCards")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try SkillCardsMetadata.deserialize(from: response.data!)
    }

    /// Updates one or more Box Skills metadata cards to a file.
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
    ///   - requestBody: Request body of updateBoxSkillCardsOnFile method
    ///   - headers: Headers of updateBoxSkillCardsOnFile method
    /// - Returns: The `SkillCardsMetadata`.
    /// - Throws: The `GeneralError`.
    public func updateBoxSkillCardsOnFile(fileId: String, requestBody: [UpdateBoxSkillCardsOnFileRequestBody], headers: UpdateBoxSkillCardsOnFileHeaders = UpdateBoxSkillCardsOnFileHeaders()) async throws -> SkillCardsMetadata {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/global/boxSkillsCards")", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json-patch+json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try SkillCardsMetadata.deserialize(from: response.data!)
    }

    /// Removes any Box Skills cards metadata from a file.
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
    ///   - headers: Headers of deleteBoxSkillCardsFromFile method
    /// - Throws: The `GeneralError`.
    public func deleteBoxSkillCardsFromFile(fileId: String, headers: DeleteBoxSkillCardsFromFileHeaders = DeleteBoxSkillCardsFromFileHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/files/")\(fileId)\("/metadata/global/boxSkillsCards")", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// An alternative method that can be used to overwrite and update all Box Skill
    /// metadata cards on a file.
    ///
    /// - Parameters:
    ///   - skillId: The ID of the skill to apply this metadata for.
    ///     Example: "33243242"
    ///   - requestBody: Request body of updateAllSkillCardsOnFile method
    ///   - headers: Headers of updateAllSkillCardsOnFile method
    /// - Throws: The `GeneralError`.
    public func updateAllSkillCardsOnFile(skillId: String, requestBody: UpdateAllSkillCardsOnFileRequestBody, headers: UpdateAllSkillCardsOnFileHeaders = UpdateAllSkillCardsOnFileHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/skill_invocations/")\(skillId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
