import Foundation

public class IntegrationMappingsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Lists [Slack integration mappings](https://support.box.com/hc/en-us/articles/4415585987859-Box-as-the-Content-Layer-for-Slack) in a users' enterprise.
    /// 
    /// You need Admin or Co-Admin role to
    /// use this endpoint.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getSlackIntegrationMapping method
    ///   - headers: Headers of getSlackIntegrationMapping method
    /// - Returns: The `IntegrationMappings`.
    /// - Throws: The `GeneralError`.
    public func getSlackIntegrationMapping(queryParams: GetSlackIntegrationMappingQueryParams = GetSlackIntegrationMappingQueryParams(), headers: GetSlackIntegrationMappingHeaders = GetSlackIntegrationMappingHeaders()) async throws -> IntegrationMappings {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit), "partner_item_type": Utils.Strings.toString(value: queryParams.partnerItemType), "partner_item_id": Utils.Strings.toString(value: queryParams.partnerItemId), "box_item_id": Utils.Strings.toString(value: queryParams.boxItemId), "box_item_type": Utils.Strings.toString(value: queryParams.boxItemType), "is_manually_created": Utils.Strings.toString(value: queryParams.isManuallyCreated)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/integration_mappings/slack")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try IntegrationMappings.deserialize(from: response.data!)
    }

    /// Creates a [Slack integration mapping](https://support.box.com/hc/en-us/articles/4415585987859-Box-as-the-Content-Layer-for-Slack)
    /// by mapping a Slack channel to a Box item.
    /// 
    /// You need Admin or Co-Admin role to
    /// use this endpoint.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createSlackIntegrationMapping method
    ///   - headers: Headers of createSlackIntegrationMapping method
    /// - Returns: The `IntegrationMapping`.
    /// - Throws: The `GeneralError`.
    public func createSlackIntegrationMapping(requestBody: IntegrationMappingSlackCreateRequest, headers: CreateSlackIntegrationMappingHeaders = CreateSlackIntegrationMappingHeaders()) async throws -> IntegrationMapping {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/integration_mappings/slack")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try IntegrationMapping.deserialize(from: response.data!)
    }

    /// Updates a [Slack integration mapping](https://support.box.com/hc/en-us/articles/4415585987859-Box-as-the-Content-Layer-for-Slack).
    /// Supports updating the Box folder ID and options.
    /// 
    /// You need Admin or Co-Admin role to
    /// use this endpoint.
    ///
    /// - Parameters:
    ///   - integrationMappingId: An ID of an integration mapping
    ///     Example: "11235432"
    ///   - requestBody: Request body of updateSlackIntegrationMappingById method
    ///   - headers: Headers of updateSlackIntegrationMappingById method
    /// - Returns: The `IntegrationMapping`.
    /// - Throws: The `GeneralError`.
    public func updateSlackIntegrationMappingById(integrationMappingId: String, requestBody: UpdateSlackIntegrationMappingByIdRequestBody = UpdateSlackIntegrationMappingByIdRequestBody(), headers: UpdateSlackIntegrationMappingByIdHeaders = UpdateSlackIntegrationMappingByIdHeaders()) async throws -> IntegrationMapping {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/integration_mappings/slack/")\(integrationMappingId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try IntegrationMapping.deserialize(from: response.data!)
    }

    /// Deletes a [Slack integration mapping](https://support.box.com/hc/en-us/articles/4415585987859-Box-as-the-Content-Layer-for-Slack).
    /// 
    /// 
    /// You need Admin or Co-Admin role to
    /// use this endpoint.
    ///
    /// - Parameters:
    ///   - integrationMappingId: An ID of an integration mapping
    ///     Example: "11235432"
    ///   - headers: Headers of deleteSlackIntegrationMappingById method
    /// - Throws: The `GeneralError`.
    public func deleteSlackIntegrationMappingById(integrationMappingId: String, headers: DeleteSlackIntegrationMappingByIdHeaders = DeleteSlackIntegrationMappingByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/integration_mappings/slack/")\(integrationMappingId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Lists [Teams integration mappings](https://support.box.com/hc/en-us/articles/360044681474-Using-Box-for-Teams) in a users' enterprise.
    /// You need Admin or Co-Admin role to
    /// use this endpoint.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getTeamsIntegrationMapping method
    ///   - headers: Headers of getTeamsIntegrationMapping method
    /// - Returns: The `IntegrationMappingsTeams`.
    /// - Throws: The `GeneralError`.
    public func getTeamsIntegrationMapping(queryParams: GetTeamsIntegrationMappingQueryParams = GetTeamsIntegrationMappingQueryParams(), headers: GetTeamsIntegrationMappingHeaders = GetTeamsIntegrationMappingHeaders()) async throws -> IntegrationMappingsTeams {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["partner_item_type": Utils.Strings.toString(value: queryParams.partnerItemType), "partner_item_id": Utils.Strings.toString(value: queryParams.partnerItemId), "box_item_id": Utils.Strings.toString(value: queryParams.boxItemId), "box_item_type": Utils.Strings.toString(value: queryParams.boxItemType)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/integration_mappings/teams")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try IntegrationMappingsTeams.deserialize(from: response.data!)
    }

    /// Creates a [Teams integration mapping](https://support.box.com/hc/en-us/articles/360044681474-Using-Box-for-Teams)
    /// by mapping a Teams channel to a Box item.
    /// You need Admin or Co-Admin role to
    /// use this endpoint.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createTeamsIntegrationMapping method
    ///   - headers: Headers of createTeamsIntegrationMapping method
    /// - Returns: The `IntegrationMappingTeams`.
    /// - Throws: The `GeneralError`.
    public func createTeamsIntegrationMapping(requestBody: IntegrationMappingTeamsCreateRequest, headers: CreateTeamsIntegrationMappingHeaders = CreateTeamsIntegrationMappingHeaders()) async throws -> IntegrationMappingTeams {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/integration_mappings/teams")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try IntegrationMappingTeams.deserialize(from: response.data!)
    }

    /// Updates a [Teams integration mapping](https://support.box.com/hc/en-us/articles/360044681474-Using-Box-for-Teams).
    /// Supports updating the Box folder ID and options.
    /// You need Admin or Co-Admin role to
    /// use this endpoint.
    ///
    /// - Parameters:
    ///   - integrationMappingId: An ID of an integration mapping
    ///     Example: "11235432"
    ///   - requestBody: Request body of updateTeamsIntegrationMappingById method
    ///   - headers: Headers of updateTeamsIntegrationMappingById method
    /// - Returns: The `IntegrationMappingTeams`.
    /// - Throws: The `GeneralError`.
    public func updateTeamsIntegrationMappingById(integrationMappingId: String, requestBody: UpdateTeamsIntegrationMappingByIdRequestBody = UpdateTeamsIntegrationMappingByIdRequestBody(), headers: UpdateTeamsIntegrationMappingByIdHeaders = UpdateTeamsIntegrationMappingByIdHeaders()) async throws -> IntegrationMappingTeams {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/integration_mappings/teams/")\(integrationMappingId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try IntegrationMappingTeams.deserialize(from: response.data!)
    }

    /// Deletes a [Teams integration mapping](https://support.box.com/hc/en-us/articles/360044681474-Using-Box-for-Teams).
    /// You need Admin or Co-Admin role to
    /// use this endpoint.
    ///
    /// - Parameters:
    ///   - integrationMappingId: An ID of an integration mapping
    ///     Example: "11235432"
    ///   - headers: Headers of deleteTeamsIntegrationMappingById method
    /// - Throws: The `GeneralError`.
    public func deleteTeamsIntegrationMappingById(integrationMappingId: String, headers: DeleteTeamsIntegrationMappingByIdHeaders = DeleteTeamsIntegrationMappingByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/integration_mappings/teams/")\(integrationMappingId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
