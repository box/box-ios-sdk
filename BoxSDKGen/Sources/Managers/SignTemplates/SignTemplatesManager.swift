import Foundation

public class SignTemplatesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Gets Box Sign templates created by a user.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getSignTemplates method
    ///   - headers: Headers of getSignTemplates method
    /// - Returns: The `SignTemplates`.
    /// - Throws: The `GeneralError`.
    public func getSignTemplates(queryParams: GetSignTemplatesQueryParams = GetSignTemplatesQueryParams(), headers: GetSignTemplatesHeaders = GetSignTemplatesHeaders()) async throws -> SignTemplates {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/sign_templates")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try SignTemplates.deserialize(from: response.data!)
    }

    /// Fetches details of a specific Box Sign template.
    ///
    /// - Parameters:
    ///   - templateId: The ID of a Box Sign template.
    ///     Example: "123075213-7d117509-8f05-42e4-a5ef-5190a319d41d"
    ///   - headers: Headers of getSignTemplateById method
    /// - Returns: The `SignTemplate`.
    /// - Throws: The `GeneralError`.
    public func getSignTemplateById(templateId: String, headers: GetSignTemplateByIdHeaders = GetSignTemplateByIdHeaders()) async throws -> SignTemplate {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/sign_templates/")\(templateId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try SignTemplate.deserialize(from: response.data!)
    }

}
