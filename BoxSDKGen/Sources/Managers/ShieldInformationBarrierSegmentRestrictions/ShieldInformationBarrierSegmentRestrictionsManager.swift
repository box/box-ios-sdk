import Foundation

public class ShieldInformationBarrierSegmentRestrictionsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves a shield information barrier segment
    /// restriction based on provided ID.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegmentRestrictionId: The ID of the shield information barrier segment Restriction.
    ///     Example: "4563"
    ///   - headers: Headers of getShieldInformationBarrierSegmentRestrictionById method
    /// - Returns: The `ShieldInformationBarrierSegmentRestriction`.
    /// - Throws: The `GeneralError`.
    public func getShieldInformationBarrierSegmentRestrictionById(shieldInformationBarrierSegmentRestrictionId: String, headers: GetShieldInformationBarrierSegmentRestrictionByIdHeaders = GetShieldInformationBarrierSegmentRestrictionByIdHeaders()) async throws -> ShieldInformationBarrierSegmentRestriction {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segment_restrictions/")\(shieldInformationBarrierSegmentRestrictionId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierSegmentRestriction.deserialize(from: response.data!)
    }

    /// Delete shield information barrier segment restriction
    /// based on provided ID.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegmentRestrictionId: The ID of the shield information barrier segment Restriction.
    ///     Example: "4563"
    ///   - headers: Headers of deleteShieldInformationBarrierSegmentRestrictionById method
    /// - Throws: The `GeneralError`.
    public func deleteShieldInformationBarrierSegmentRestrictionById(shieldInformationBarrierSegmentRestrictionId: String, headers: DeleteShieldInformationBarrierSegmentRestrictionByIdHeaders = DeleteShieldInformationBarrierSegmentRestrictionByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segment_restrictions/")\(shieldInformationBarrierSegmentRestrictionId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Lists shield information barrier segment restrictions
    /// based on provided segment ID.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShieldInformationBarrierSegmentRestrictions method
    ///   - headers: Headers of getShieldInformationBarrierSegmentRestrictions method
    /// - Returns: The `ShieldInformationBarrierSegmentRestrictions`.
    /// - Throws: The `GeneralError`.
    public func getShieldInformationBarrierSegmentRestrictions(queryParams: GetShieldInformationBarrierSegmentRestrictionsQueryParams, headers: GetShieldInformationBarrierSegmentRestrictionsHeaders = GetShieldInformationBarrierSegmentRestrictionsHeaders()) async throws -> ShieldInformationBarrierSegmentRestrictions {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["shield_information_barrier_segment_id": Utils.Strings.toString(value: queryParams.shieldInformationBarrierSegmentId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segment_restrictions")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierSegmentRestrictions.deserialize(from: response.data!)
    }

    /// Creates a shield information barrier
    /// segment restriction object.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShieldInformationBarrierSegmentRestriction method
    ///   - headers: Headers of createShieldInformationBarrierSegmentRestriction method
    /// - Returns: The `ShieldInformationBarrierSegmentRestriction`.
    /// - Throws: The `GeneralError`.
    public func createShieldInformationBarrierSegmentRestriction(requestBody: CreateShieldInformationBarrierSegmentRestrictionRequestBody, headers: CreateShieldInformationBarrierSegmentRestrictionHeaders = CreateShieldInformationBarrierSegmentRestrictionHeaders()) async throws -> ShieldInformationBarrierSegmentRestriction {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segment_restrictions")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierSegmentRestriction.deserialize(from: response.data!)
    }

}
