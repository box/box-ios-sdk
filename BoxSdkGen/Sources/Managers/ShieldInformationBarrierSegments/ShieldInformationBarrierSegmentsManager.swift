import Foundation

public class ShieldInformationBarrierSegmentsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves shield information barrier segment based on provided ID..
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegmentId: The ID of the shield information barrier segment.
    ///     Example: "3423"
    ///   - headers: Headers of getShieldInformationBarrierSegmentById method
    /// - Returns: The `ShieldInformationBarrierSegment`.
    /// - Throws: The `GeneralError`.
    public func getShieldInformationBarrierSegmentById(shieldInformationBarrierSegmentId: String, headers: GetShieldInformationBarrierSegmentByIdHeaders = GetShieldInformationBarrierSegmentByIdHeaders()) async throws -> ShieldInformationBarrierSegment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segments/")\(shieldInformationBarrierSegmentId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierSegment.deserialize(from: response.data!)
    }

    /// Deletes the shield information barrier segment
    /// based on provided ID.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegmentId: The ID of the shield information barrier segment.
    ///     Example: "3423"
    ///   - headers: Headers of deleteShieldInformationBarrierSegmentById method
    /// - Throws: The `GeneralError`.
    public func deleteShieldInformationBarrierSegmentById(shieldInformationBarrierSegmentId: String, headers: DeleteShieldInformationBarrierSegmentByIdHeaders = DeleteShieldInformationBarrierSegmentByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segments/")\(shieldInformationBarrierSegmentId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Updates the shield information barrier segment based on provided ID..
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegmentId: The ID of the shield information barrier segment.
    ///     Example: "3423"
    ///   - requestBody: Request body of updateShieldInformationBarrierSegmentById method
    ///   - headers: Headers of updateShieldInformationBarrierSegmentById method
    /// - Returns: The `ShieldInformationBarrierSegment`.
    /// - Throws: The `GeneralError`.
    public func updateShieldInformationBarrierSegmentById(shieldInformationBarrierSegmentId: String, requestBody: UpdateShieldInformationBarrierSegmentByIdRequestBody = UpdateShieldInformationBarrierSegmentByIdRequestBody(), headers: UpdateShieldInformationBarrierSegmentByIdHeaders = UpdateShieldInformationBarrierSegmentByIdHeaders()) async throws -> ShieldInformationBarrierSegment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segments/")\(shieldInformationBarrierSegmentId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierSegment.deserialize(from: response.data!)
    }

    /// Retrieves a list of shield information barrier segment objects
    /// for the specified Information Barrier ID.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShieldInformationBarrierSegments method
    ///   - headers: Headers of getShieldInformationBarrierSegments method
    /// - Returns: The `ShieldInformationBarrierSegments`.
    /// - Throws: The `GeneralError`.
    public func getShieldInformationBarrierSegments(queryParams: GetShieldInformationBarrierSegmentsQueryParams, headers: GetShieldInformationBarrierSegmentsHeaders = GetShieldInformationBarrierSegmentsHeaders()) async throws -> ShieldInformationBarrierSegments {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["shield_information_barrier_id": Utils.Strings.toString(value: queryParams.shieldInformationBarrierId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segments")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierSegments.deserialize(from: response.data!)
    }

    /// Creates a shield information barrier segment.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShieldInformationBarrierSegment method
    ///   - headers: Headers of createShieldInformationBarrierSegment method
    /// - Returns: The `ShieldInformationBarrierSegment`.
    /// - Throws: The `GeneralError`.
    public func createShieldInformationBarrierSegment(requestBody: CreateShieldInformationBarrierSegmentRequestBody, headers: CreateShieldInformationBarrierSegmentHeaders = CreateShieldInformationBarrierSegmentHeaders()) async throws -> ShieldInformationBarrierSegment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_segments")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierSegment.deserialize(from: response.data!)
    }

}
