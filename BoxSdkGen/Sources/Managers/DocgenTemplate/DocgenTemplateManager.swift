import Foundation

public class DocgenTemplateManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Marks a file as a Box Doc Gen template.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createDocgenTemplateV2025R0 method
    ///   - headers: Headers of createDocgenTemplateV2025R0 method
    /// - Returns: The `DocGenTemplateBaseV2025R0`.
    /// - Throws: The `GeneralError`.
    public func createDocgenTemplateV2025R0(requestBody: DocGenTemplateCreateRequestV2025R0, headers: CreateDocgenTemplateV2025R0Headers = CreateDocgenTemplateV2025R0Headers()) async throws -> DocGenTemplateBaseV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/docgen_templates")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocGenTemplateBaseV2025R0.deserialize(from: response.data!)
    }

    /// Lists Box Doc Gen templates on which the user is a collaborator.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getDocgenTemplatesV2025R0 method
    ///   - headers: Headers of getDocgenTemplatesV2025R0 method
    /// - Returns: The `DocGenTemplatesV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getDocgenTemplatesV2025R0(queryParams: GetDocgenTemplatesV2025R0QueryParams = GetDocgenTemplatesV2025R0QueryParams(), headers: GetDocgenTemplatesV2025R0Headers = GetDocgenTemplatesV2025R0Headers()) async throws -> DocGenTemplatesV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/docgen_templates")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocGenTemplatesV2025R0.deserialize(from: response.data!)
    }

    /// Unmarks file as Box Doc Gen template
    ///
    /// - Parameters:
    ///   - templateId: ID of the file which will no longer be marked as a Box Doc Gen template.
    ///     Example: "123"
    ///   - headers: Headers of deleteDocgenTemplateByIdV2025R0 method
    /// - Throws: The `GeneralError`.
    public func deleteDocgenTemplateByIdV2025R0(templateId: String, headers: DeleteDocgenTemplateByIdV2025R0Headers = DeleteDocgenTemplateByIdV2025R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/docgen_templates/")\(templateId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Lists details of a specific Box Doc Gen template.
    ///
    /// - Parameters:
    ///   - templateId: The ID of a Box Doc Gen template.
    ///     Example: 123
    ///   - headers: Headers of getDocgenTemplateByIdV2025R0 method
    /// - Returns: The `DocGenTemplateV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getDocgenTemplateByIdV2025R0(templateId: String, headers: GetDocgenTemplateByIdV2025R0Headers = GetDocgenTemplateByIdV2025R0Headers()) async throws -> DocGenTemplateV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/docgen_templates/")\(templateId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocGenTemplateV2025R0.deserialize(from: response.data!)
    }

    /// Lists all tags in a Box Doc Gen template.
    ///
    /// - Parameters:
    ///   - templateId: ID of template.
    ///     Example: 123
    ///   - queryParams: Query parameters of getDocgenTemplateTagsV2025R0 method
    ///   - headers: Headers of getDocgenTemplateTagsV2025R0 method
    /// - Returns: The `DocGenTagsV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getDocgenTemplateTagsV2025R0(templateId: String, queryParams: GetDocgenTemplateTagsV2025R0QueryParams = GetDocgenTemplateTagsV2025R0QueryParams(), headers: GetDocgenTemplateTagsV2025R0Headers = GetDocgenTemplateTagsV2025R0Headers()) async throws -> DocGenTagsV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["template_version_id": Utils.Strings.toString(value: queryParams.templateVersionId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/docgen_templates/")\(templateId)\("/tags")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocGenTagsV2025R0.deserialize(from: response.data!)
    }

    /// Lists the users jobs which use this template.
    ///
    /// - Parameters:
    ///   - templateId: Id of template to fetch jobs for.
    ///     Example: 123
    ///   - queryParams: Query parameters of getDocgenTemplateJobByIdV2025R0 method
    ///   - headers: Headers of getDocgenTemplateJobByIdV2025R0 method
    /// - Returns: The `DocGenJobsV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getDocgenTemplateJobByIdV2025R0(templateId: String, queryParams: GetDocgenTemplateJobByIdV2025R0QueryParams = GetDocgenTemplateJobByIdV2025R0QueryParams(), headers: GetDocgenTemplateJobByIdV2025R0Headers = GetDocgenTemplateJobByIdV2025R0Headers()) async throws -> DocGenJobsV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/docgen_template_jobs/")\(templateId)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocGenJobsV2025R0.deserialize(from: response.data!)
    }

}
