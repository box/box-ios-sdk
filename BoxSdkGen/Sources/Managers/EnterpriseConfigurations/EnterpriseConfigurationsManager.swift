import Foundation

public class EnterpriseConfigurationsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves the configuration for an enterprise.
    ///
    /// - Parameters:
    ///   - enterpriseId: The ID of the enterprise.
    ///     Example: "3442311"
    ///   - queryParams: Query parameters of getEnterpriseConfigurationByIdV2025R0 method
    ///   - headers: Headers of getEnterpriseConfigurationByIdV2025R0 method
    /// - Returns: The `EnterpriseConfigurationV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getEnterpriseConfigurationByIdV2025R0(enterpriseId: String, queryParams: GetEnterpriseConfigurationByIdV2025R0QueryParams, headers: GetEnterpriseConfigurationByIdV2025R0Headers = GetEnterpriseConfigurationByIdV2025R0Headers()) async throws -> EnterpriseConfigurationV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["categories": Utils.Strings.toString(value: queryParams.categories)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/enterprise_configurations/")\(Utils.Strings.toString(value: enterpriseId)!)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try EnterpriseConfigurationV2025R0.deserialize(from: response.data!)
    }

}
