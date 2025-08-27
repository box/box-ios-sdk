import Foundation

public class TermsOfServicesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns the current terms of service text and settings
    /// for the enterprise.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getTermsOfService method
    ///   - headers: Headers of getTermsOfService method
    /// - Returns: The `TermsOfServices`.
    /// - Throws: The `GeneralError`.
    public func getTermsOfService(queryParams: GetTermsOfServiceQueryParams = GetTermsOfServiceQueryParams(), headers: GetTermsOfServiceHeaders = GetTermsOfServiceHeaders()) async throws -> TermsOfServices {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["tos_type": Utils.Strings.toString(value: queryParams.tosType)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/terms_of_services")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TermsOfServices.deserialize(from: response.data!)
    }

    /// Creates a terms of service for a given enterprise
    /// and type of user.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createTermsOfService method
    ///   - headers: Headers of createTermsOfService method
    /// - Returns: The `TermsOfService`.
    /// - Throws: The `GeneralError`.
    public func createTermsOfService(requestBody: CreateTermsOfServiceRequestBody, headers: CreateTermsOfServiceHeaders = CreateTermsOfServiceHeaders()) async throws -> TermsOfService {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/terms_of_services")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TermsOfService.deserialize(from: response.data!)
    }

    /// Fetches a specific terms of service.
    ///
    /// - Parameters:
    ///   - termsOfServiceId: The ID of the terms of service.
    ///     Example: "324234"
    ///   - headers: Headers of getTermsOfServiceById method
    /// - Returns: The `TermsOfService`.
    /// - Throws: The `GeneralError`.
    public func getTermsOfServiceById(termsOfServiceId: String, headers: GetTermsOfServiceByIdHeaders = GetTermsOfServiceByIdHeaders()) async throws -> TermsOfService {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/terms_of_services/")\(termsOfServiceId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TermsOfService.deserialize(from: response.data!)
    }

    /// Updates a specific terms of service.
    ///
    /// - Parameters:
    ///   - termsOfServiceId: The ID of the terms of service.
    ///     Example: "324234"
    ///   - requestBody: Request body of updateTermsOfServiceById method
    ///   - headers: Headers of updateTermsOfServiceById method
    /// - Returns: The `TermsOfService`.
    /// - Throws: The `GeneralError`.
    public func updateTermsOfServiceById(termsOfServiceId: String, requestBody: UpdateTermsOfServiceByIdRequestBody, headers: UpdateTermsOfServiceByIdHeaders = UpdateTermsOfServiceByIdHeaders()) async throws -> TermsOfService {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/terms_of_services/")\(termsOfServiceId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TermsOfService.deserialize(from: response.data!)
    }

}
