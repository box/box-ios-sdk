import Foundation

public class WebhooksManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns all defined webhooks for the requesting application.
    /// 
    /// This API only returns webhooks that are applied to files or folders that are
    /// owned by the authenticated user. This means that an admin can not see webhooks
    /// created by a service account unless the admin has access to those folders, and
    /// vice versa.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getWebhooks method
    ///   - headers: Headers of getWebhooks method
    /// - Returns: The `Webhooks`.
    /// - Throws: The `GeneralError`.
    public func getWebhooks(queryParams: GetWebhooksQueryParams = GetWebhooksQueryParams(), headers: GetWebhooksHeaders = GetWebhooksHeaders()) async throws -> Webhooks {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/webhooks")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Webhooks.deserialize(from: response.data!)
    }

    /// Creates a webhook.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createWebhook method
    ///   - headers: Headers of createWebhook method
    /// - Returns: The `Webhook`.
    /// - Throws: The `GeneralError`.
    public func createWebhook(requestBody: CreateWebhookRequestBody, headers: CreateWebhookHeaders = CreateWebhookHeaders()) async throws -> Webhook {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/webhooks")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Webhook.deserialize(from: response.data!)
    }

    /// Retrieves a specific webhook
    ///
    /// - Parameters:
    ///   - webhookId: The ID of the webhook.
    ///     Example: "3321123"
    ///   - headers: Headers of getWebhookById method
    /// - Returns: The `Webhook`.
    /// - Throws: The `GeneralError`.
    public func getWebhookById(webhookId: String, headers: GetWebhookByIdHeaders = GetWebhookByIdHeaders()) async throws -> Webhook {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/webhooks/")\(webhookId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Webhook.deserialize(from: response.data!)
    }

    /// Updates a webhook.
    ///
    /// - Parameters:
    ///   - webhookId: The ID of the webhook.
    ///     Example: "3321123"
    ///   - requestBody: Request body of updateWebhookById method
    ///   - headers: Headers of updateWebhookById method
    /// - Returns: The `Webhook`.
    /// - Throws: The `GeneralError`.
    public func updateWebhookById(webhookId: String, requestBody: UpdateWebhookByIdRequestBody = UpdateWebhookByIdRequestBody(), headers: UpdateWebhookByIdHeaders = UpdateWebhookByIdHeaders()) async throws -> Webhook {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/webhooks/")\(webhookId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Webhook.deserialize(from: response.data!)
    }

    /// Deletes a webhook.
    ///
    /// - Parameters:
    ///   - webhookId: The ID of the webhook.
    ///     Example: "3321123"
    ///   - headers: Headers of deleteWebhookById method
    /// - Throws: The `GeneralError`.
    public func deleteWebhookById(webhookId: String, headers: DeleteWebhookByIdHeaders = DeleteWebhookByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/webhooks/")\(webhookId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
