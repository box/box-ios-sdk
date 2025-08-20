import Foundation

public class ShieldListsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves all shield lists in the enterprise.
    ///
    /// - Parameters:
    ///   - headers: Headers of getShieldListsV2025R0 method
    /// - Returns: The `ShieldListsV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getShieldListsV2025R0(headers: GetShieldListsV2025R0Headers = GetShieldListsV2025R0Headers()) async throws -> ShieldListsV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_lists")", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldListsV2025R0.deserialize(from: response.data!)
    }

    /// Creates a shield list.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShieldListV2025R0 method
    ///   - headers: Headers of createShieldListV2025R0 method
    /// - Returns: The `ShieldListV2025R0`.
    /// - Throws: The `GeneralError`.
    public func createShieldListV2025R0(requestBody: ShieldListsCreateV2025R0, headers: CreateShieldListV2025R0Headers = CreateShieldListV2025R0Headers()) async throws -> ShieldListV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_lists")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldListV2025R0.deserialize(from: response.data!)
    }

    /// Retrieves a single shield list by its ID.
    ///
    /// - Parameters:
    ///   - shieldListId: The unique identifier that represents a shield list.
    ///     The ID for any Shield List can be determined by the response from the endpoint
    ///     fetching all shield lists for the enterprise.
    ///     Example: "90fb0e17-c332-40ed-b4f9-fa8908fbbb24 "
    ///   - headers: Headers of getShieldListByIdV2025R0 method
    /// - Returns: The `ShieldListV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getShieldListByIdV2025R0(shieldListId: String, headers: GetShieldListByIdV2025R0Headers = GetShieldListByIdV2025R0Headers()) async throws -> ShieldListV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_lists/")\(shieldListId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldListV2025R0.deserialize(from: response.data!)
    }

    /// Delete a single shield list by its ID.
    ///
    /// - Parameters:
    ///   - shieldListId: The unique identifier that represents a shield list.
    ///     The ID for any Shield List can be determined by the response from the endpoint
    ///     fetching all shield lists for the enterprise.
    ///     Example: "90fb0e17-c332-40ed-b4f9-fa8908fbbb24 "
    ///   - headers: Headers of deleteShieldListByIdV2025R0 method
    /// - Throws: The `GeneralError`.
    public func deleteShieldListByIdV2025R0(shieldListId: String, headers: DeleteShieldListByIdV2025R0Headers = DeleteShieldListByIdV2025R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_lists/")\(shieldListId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Updates a shield list.
    ///
    /// - Parameters:
    ///   - shieldListId: The unique identifier that represents a shield list.
    ///     The ID for any Shield List can be determined by the response from the endpoint
    ///     fetching all shield lists for the enterprise.
    ///     Example: "90fb0e17-c332-40ed-b4f9-fa8908fbbb24 "
    ///   - requestBody: Request body of updateShieldListByIdV2025R0 method
    ///   - headers: Headers of updateShieldListByIdV2025R0 method
    /// - Returns: The `ShieldListV2025R0`.
    /// - Throws: The `GeneralError`.
    public func updateShieldListByIdV2025R0(shieldListId: String, requestBody: ShieldListsUpdateV2025R0, headers: UpdateShieldListByIdV2025R0Headers = UpdateShieldListByIdV2025R0Headers()) async throws -> ShieldListV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_lists/")\(shieldListId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldListV2025R0.deserialize(from: response.data!)
    }

}
