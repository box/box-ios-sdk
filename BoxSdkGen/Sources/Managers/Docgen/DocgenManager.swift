import Foundation

public class DocgenManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Get details of the Box Doc Gen job.
    ///
    /// - Parameters:
    ///   - jobId: Box Doc Gen job ID.
    ///     Example: 123
    ///   - headers: Headers of getDocgenJobByIdV2025R0 method
    /// - Returns: The `DocGenJobV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getDocgenJobByIdV2025R0(jobId: String, headers: GetDocgenJobByIdV2025R0Headers = GetDocgenJobByIdV2025R0Headers()) async throws -> DocGenJobV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/docgen_jobs/")\(jobId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocGenJobV2025R0.deserialize(from: response.data!)
    }

    /// Lists all Box Doc Gen jobs for a user.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getDocgenJobsV2025R0 method
    ///   - headers: Headers of getDocgenJobsV2025R0 method
    /// - Returns: The `DocGenJobsFullV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getDocgenJobsV2025R0(queryParams: GetDocgenJobsV2025R0QueryParams = GetDocgenJobsV2025R0QueryParams(), headers: GetDocgenJobsV2025R0Headers = GetDocgenJobsV2025R0Headers()) async throws -> DocGenJobsFullV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/docgen_jobs")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocGenJobsFullV2025R0.deserialize(from: response.data!)
    }

    /// Lists Box Doc Gen jobs in a batch
    ///
    /// - Parameters:
    ///   - batchId: Box Doc Gen batch ID.
    ///     Example: 123
    ///   - queryParams: Query parameters of getDocgenBatchJobByIdV2025R0 method
    ///   - headers: Headers of getDocgenBatchJobByIdV2025R0 method
    /// - Returns: The `DocGenJobsV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getDocgenBatchJobByIdV2025R0(batchId: String, queryParams: GetDocgenBatchJobByIdV2025R0QueryParams = GetDocgenBatchJobByIdV2025R0QueryParams(), headers: GetDocgenBatchJobByIdV2025R0Headers = GetDocgenBatchJobByIdV2025R0Headers()) async throws -> DocGenJobsV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/docgen_batch_jobs/")\(batchId)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocGenJobsV2025R0.deserialize(from: response.data!)
    }

    /// Generates a document using a Box Doc Gen template.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createDocgenBatchV2025R0 method
    ///   - headers: Headers of createDocgenBatchV2025R0 method
    /// - Returns: The `DocGenBatchBaseV2025R0`.
    /// - Throws: The `GeneralError`.
    public func createDocgenBatchV2025R0(requestBody: DocGenBatchCreateRequestV2025R0, headers: CreateDocgenBatchV2025R0Headers = CreateDocgenBatchV2025R0Headers()) async throws -> DocGenBatchBaseV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/docgen_batches")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocGenBatchBaseV2025R0.deserialize(from: response.data!)
    }

}
