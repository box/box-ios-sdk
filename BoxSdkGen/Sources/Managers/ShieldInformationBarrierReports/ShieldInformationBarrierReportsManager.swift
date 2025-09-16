import Foundation

public class ShieldInformationBarrierReportsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Lists shield information barrier reports.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShieldInformationBarrierReports method
    ///   - headers: Headers of getShieldInformationBarrierReports method
    /// - Returns: The `ShieldInformationBarrierReports`.
    /// - Throws: The `GeneralError`.
    public func getShieldInformationBarrierReports(queryParams: GetShieldInformationBarrierReportsQueryParams, headers: GetShieldInformationBarrierReportsHeaders = GetShieldInformationBarrierReportsHeaders()) async throws -> ShieldInformationBarrierReports {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["shield_information_barrier_id": Utils.Strings.toString(value: queryParams.shieldInformationBarrierId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_reports")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierReports.deserialize(from: response.data!)
    }

    /// Creates a shield information barrier report for a given barrier.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShieldInformationBarrierReport method
    ///   - headers: Headers of createShieldInformationBarrierReport method
    /// - Returns: The `ShieldInformationBarrierReport`.
    /// - Throws: The `GeneralError`.
    public func createShieldInformationBarrierReport(requestBody: ShieldInformationBarrierReference, headers: CreateShieldInformationBarrierReportHeaders = CreateShieldInformationBarrierReportHeaders()) async throws -> ShieldInformationBarrierReport {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_reports")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierReport.deserialize(from: response.data!)
    }

    /// Retrieves a shield information barrier report by its ID.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierReportId: The ID of the shield information barrier Report.
    ///     Example: "3423"
    ///   - headers: Headers of getShieldInformationBarrierReportById method
    /// - Returns: The `ShieldInformationBarrierReport`.
    /// - Throws: The `GeneralError`.
    public func getShieldInformationBarrierReportById(shieldInformationBarrierReportId: String, headers: GetShieldInformationBarrierReportByIdHeaders = GetShieldInformationBarrierReportByIdHeaders()) async throws -> ShieldInformationBarrierReport {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shield_information_barrier_reports/")\(shieldInformationBarrierReportId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShieldInformationBarrierReport.deserialize(from: response.data!)
    }

}
