import Foundation

public class SharedLinksWebLinksManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns the web link represented by a shared link.
    /// 
    /// A shared web link can be represented by a shared link,
    /// which can originate within the current enterprise or within another.
    /// 
    /// This endpoint allows an application to retrieve information about a
    /// shared web link when only given a shared link.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of findWebLinkForSharedLink method
    ///   - headers: Headers of findWebLinkForSharedLink method
    /// - Returns: The `WebLink`.
    /// - Throws: The `GeneralError`.
    public func findWebLinkForSharedLink(queryParams: FindWebLinkForSharedLinkQueryParams = FindWebLinkForSharedLinkQueryParams(), headers: FindWebLinkForSharedLinkHeaders) async throws -> WebLink {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["if-none-match": Utils.Strings.toString(value: headers.ifNoneMatch), "boxapi": Utils.Strings.toString(value: headers.boxapi)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shared_items#web_links")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try WebLink.deserialize(from: response.data!)
    }

    /// Gets the information for a shared link on a web link.
    ///
    /// - Parameters:
    ///   - webLinkId: The ID of the web link.
    ///     Example: "12345"
    ///   - queryParams: Query parameters of getSharedLinkForWebLink method
    ///   - headers: Headers of getSharedLinkForWebLink method
    /// - Returns: The `WebLink`.
    /// - Throws: The `GeneralError`.
    public func getSharedLinkForWebLink(webLinkId: String, queryParams: GetSharedLinkForWebLinkQueryParams, headers: GetSharedLinkForWebLinkHeaders = GetSharedLinkForWebLinkHeaders()) async throws -> WebLink {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/web_links/")\(webLinkId)\("#get_shared_link")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try WebLink.deserialize(from: response.data!)
    }

    /// Adds a shared link to a web link.
    ///
    /// - Parameters:
    ///   - webLinkId: The ID of the web link.
    ///     Example: "12345"
    ///   - requestBody: Request body of addShareLinkToWebLink method
    ///   - queryParams: Query parameters of addShareLinkToWebLink method
    ///   - headers: Headers of addShareLinkToWebLink method
    /// - Returns: The `WebLink`.
    /// - Throws: The `GeneralError`.
    public func addShareLinkToWebLink(webLinkId: String, requestBody: AddShareLinkToWebLinkRequestBody = AddShareLinkToWebLinkRequestBody(), queryParams: AddShareLinkToWebLinkQueryParams, headers: AddShareLinkToWebLinkHeaders = AddShareLinkToWebLinkHeaders()) async throws -> WebLink {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/web_links/")\(webLinkId)\("#add_shared_link")", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try WebLink.deserialize(from: response.data!)
    }

    /// Updates a shared link on a web link.
    ///
    /// - Parameters:
    ///   - webLinkId: The ID of the web link.
    ///     Example: "12345"
    ///   - requestBody: Request body of updateSharedLinkOnWebLink method
    ///   - queryParams: Query parameters of updateSharedLinkOnWebLink method
    ///   - headers: Headers of updateSharedLinkOnWebLink method
    /// - Returns: The `WebLink`.
    /// - Throws: The `GeneralError`.
    public func updateSharedLinkOnWebLink(webLinkId: String, requestBody: UpdateSharedLinkOnWebLinkRequestBody = UpdateSharedLinkOnWebLinkRequestBody(), queryParams: UpdateSharedLinkOnWebLinkQueryParams, headers: UpdateSharedLinkOnWebLinkHeaders = UpdateSharedLinkOnWebLinkHeaders()) async throws -> WebLink {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/web_links/")\(webLinkId)\("#update_shared_link")", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try WebLink.deserialize(from: response.data!)
    }

    /// Removes a shared link from a web link.
    ///
    /// - Parameters:
    ///   - webLinkId: The ID of the web link.
    ///     Example: "12345"
    ///   - requestBody: Request body of removeSharedLinkFromWebLink method
    ///   - queryParams: Query parameters of removeSharedLinkFromWebLink method
    ///   - headers: Headers of removeSharedLinkFromWebLink method
    /// - Returns: The `WebLink`.
    /// - Throws: The `GeneralError`.
    public func removeSharedLinkFromWebLink(webLinkId: String, requestBody: RemoveSharedLinkFromWebLinkRequestBody = RemoveSharedLinkFromWebLinkRequestBody(), queryParams: RemoveSharedLinkFromWebLinkQueryParams, headers: RemoveSharedLinkFromWebLinkHeaders = RemoveSharedLinkFromWebLinkHeaders()) async throws -> WebLink {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/web_links/")\(webLinkId)\("#remove_shared_link")", method: "PUT", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try WebLink.deserialize(from: response.data!)
    }

}
