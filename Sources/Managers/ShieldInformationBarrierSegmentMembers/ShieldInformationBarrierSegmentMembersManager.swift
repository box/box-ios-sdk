import Foundation

public class ShieldInformationBarrierSegmentMembersManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves a shield information barrier
    /// segment member by its ID.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegmentMemberId: The ID of the shield information barrier segment Member.
    ///     Example: "7815"
    ///   - headers: Headers of getShieldInformationBarrierSegmentMemberById method
    /// - Returns: The `ShieldInformationBarrierSegmentMember`.
    /// - Throws: The `GeneralError`.
    public func getShieldInformationBarrierSegmentMemberById(shieldInformationBarrierSegmentMemberId: String, headers: GetShieldInformationBarrierSegmentMemberByIdHeaders = GetShieldInformationBarrierSegmentMemberByIdHeaders()) async throws -> ShieldInformationBarrierSegmentMember {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segment_members/")\(shieldInformationBarrierSegmentMemberId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierSegmentMember.deserialize(from: response.data!)
    }

    /// Deletes a shield information barrier
    /// segment member based on provided ID.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegmentMemberId: The ID of the shield information barrier segment Member.
    ///     Example: "7815"
    ///   - headers: Headers of deleteShieldInformationBarrierSegmentMemberById method
    /// - Throws: The `GeneralError`.
    public func deleteShieldInformationBarrierSegmentMemberById(shieldInformationBarrierSegmentMemberId: String, headers: DeleteShieldInformationBarrierSegmentMemberByIdHeaders = DeleteShieldInformationBarrierSegmentMemberByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segment_members/")\(shieldInformationBarrierSegmentMemberId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Lists shield information barrier segment members
    /// based on provided segment IDs.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShieldInformationBarrierSegmentMembers method
    ///   - headers: Headers of getShieldInformationBarrierSegmentMembers method
    /// - Returns: The `ShieldInformationBarrierSegmentMembers`.
    /// - Throws: The `GeneralError`.
    public func getShieldInformationBarrierSegmentMembers(queryParams: GetShieldInformationBarrierSegmentMembersQueryParams, headers: GetShieldInformationBarrierSegmentMembersHeaders = GetShieldInformationBarrierSegmentMembersHeaders()) async throws -> ShieldInformationBarrierSegmentMembers {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["shield_information_barrier_segment_id": Utils.Strings.toString(value: queryParams.shieldInformationBarrierSegmentId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segment_members")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierSegmentMembers.deserialize(from: response.data!)
    }

    /// Creates a new shield information barrier segment member.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShieldInformationBarrierSegmentMember method
    ///   - headers: Headers of createShieldInformationBarrierSegmentMember method
    /// - Returns: The `ShieldInformationBarrierSegmentMember`.
    /// - Throws: The `GeneralError`.
    public func createShieldInformationBarrierSegmentMember(requestBody: CreateShieldInformationBarrierSegmentMemberRequestBody, headers: CreateShieldInformationBarrierSegmentMemberHeaders = CreateShieldInformationBarrierSegmentMemberHeaders()) async throws -> ShieldInformationBarrierSegmentMember {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segment_members")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierSegmentMember.deserialize(from: response.data!)
    }

}
