import Foundation

public class MetadataTemplatesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Finds a metadata template by searching for the ID of an instance of the
    /// template.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getMetadataTemplatesByInstanceId method
    ///   - headers: Headers of getMetadataTemplatesByInstanceId method
    /// - Returns: The `MetadataTemplates`.
    /// - Throws: The `GeneralError`.
    public func getMetadataTemplatesByInstanceId(queryParams: GetMetadataTemplatesByInstanceIdQueryParams, headers: GetMetadataTemplatesByInstanceIdHeaders = GetMetadataTemplatesByInstanceIdHeaders()) async throws -> MetadataTemplates {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["metadata_instance_id": Utils.Strings.toString(value: queryParams.metadataInstanceId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_templates")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTemplates.deserialize(from: response.data!)
    }

    /// Retrieves a metadata template by its `scope` and `templateKey` values.
    /// 
    /// To find the `scope` and `templateKey` for a template, list all templates for
    /// an enterprise or globally, or list all templates applied to a file or folder.
    ///
    /// - Parameters:
    ///   - scope: The scope of the metadata template
    ///     Example: "global"
    ///   - templateKey: The name of the metadata template
    ///     Example: "properties"
    ///   - headers: Headers of getMetadataTemplate method
    /// - Returns: The `MetadataTemplate`.
    /// - Throws: The `GeneralError`.
    public func getMetadataTemplate(scope: GetMetadataTemplateScope, templateKey: String, headers: GetMetadataTemplateHeaders = GetMetadataTemplateHeaders()) async throws -> MetadataTemplate {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_templates/")\(scope)\("/")\(templateKey)\("/schema")", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTemplate.deserialize(from: response.data!)
    }

    /// Updates a metadata template.
    /// 
    /// The metadata template can only be updated if the template
    /// already exists.
    /// 
    /// The update is applied atomically. If any errors occur during the
    /// application of the operations, the metadata template will not be changed.
    ///
    /// - Parameters:
    ///   - scope: The scope of the metadata template
    ///     Example: "global"
    ///   - templateKey: The name of the metadata template
    ///     Example: "properties"
    ///   - requestBody: Request body of updateMetadataTemplate method
    ///   - headers: Headers of updateMetadataTemplate method
    /// - Returns: The `MetadataTemplate`.
    /// - Throws: The `GeneralError`.
    public func updateMetadataTemplate(scope: UpdateMetadataTemplateScope, templateKey: String, requestBody: [UpdateMetadataTemplateRequestBody], headers: UpdateMetadataTemplateHeaders = UpdateMetadataTemplateHeaders()) async throws -> MetadataTemplate {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_templates/")\(scope)\("/")\(templateKey)\("/schema")", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json-patch+json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTemplate.deserialize(from: response.data!)
    }

    /// Delete a metadata template and its instances.
    /// This deletion is permanent and can not be reversed.
    ///
    /// - Parameters:
    ///   - scope: The scope of the metadata template
    ///     Example: "global"
    ///   - templateKey: The name of the metadata template
    ///     Example: "properties"
    ///   - headers: Headers of deleteMetadataTemplate method
    /// - Throws: The `GeneralError`.
    public func deleteMetadataTemplate(scope: DeleteMetadataTemplateScope, templateKey: String, headers: DeleteMetadataTemplateHeaders = DeleteMetadataTemplateHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_templates/")\(scope)\("/")\(templateKey)\("/schema")", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Retrieves a metadata template by its ID.
    ///
    /// - Parameters:
    ///   - templateId: The ID of the template
    ///     Example: "f7a9891f"
    ///   - headers: Headers of getMetadataTemplateById method
    /// - Returns: The `MetadataTemplate`.
    /// - Throws: The `GeneralError`.
    public func getMetadataTemplateById(templateId: String, headers: GetMetadataTemplateByIdHeaders = GetMetadataTemplateByIdHeaders()) async throws -> MetadataTemplate {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_templates/")\(templateId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTemplate.deserialize(from: response.data!)
    }

    /// Used to retrieve all generic, global metadata templates available to all
    /// enterprises using Box.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getGlobalMetadataTemplates method
    ///   - headers: Headers of getGlobalMetadataTemplates method
    /// - Returns: The `MetadataTemplates`.
    /// - Throws: The `GeneralError`.
    public func getGlobalMetadataTemplates(queryParams: GetGlobalMetadataTemplatesQueryParams = GetGlobalMetadataTemplatesQueryParams(), headers: GetGlobalMetadataTemplatesHeaders = GetGlobalMetadataTemplatesHeaders()) async throws -> MetadataTemplates {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_templates/global")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTemplates.deserialize(from: response.data!)
    }

    /// Used to retrieve all metadata templates created to be used specifically within
    /// the user's enterprise
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getEnterpriseMetadataTemplates method
    ///   - headers: Headers of getEnterpriseMetadataTemplates method
    /// - Returns: The `MetadataTemplates`.
    /// - Throws: The `GeneralError`.
    public func getEnterpriseMetadataTemplates(queryParams: GetEnterpriseMetadataTemplatesQueryParams = GetEnterpriseMetadataTemplatesQueryParams(), headers: GetEnterpriseMetadataTemplatesHeaders = GetEnterpriseMetadataTemplatesHeaders()) async throws -> MetadataTemplates {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_templates/enterprise")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTemplates.deserialize(from: response.data!)
    }

    /// Creates a new metadata template that can be applied to
    /// files and folders.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createMetadataTemplate method
    ///   - headers: Headers of createMetadataTemplate method
    /// - Returns: The `MetadataTemplate`.
    /// - Throws: The `GeneralError`.
    public func createMetadataTemplate(requestBody: CreateMetadataTemplateRequestBody, headers: CreateMetadataTemplateHeaders = CreateMetadataTemplateHeaders()) async throws -> MetadataTemplate {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_templates/schema")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTemplate.deserialize(from: response.data!)
    }

}
