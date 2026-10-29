import Foundation

public class DocumentSplitManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Initiates a Document Split job for the supplied source file. The job runs
    /// asynchronously; clients can poll the returned job ID to track progress.
    /// 
    /// All split-specific input lives under `split_input`. When
    /// `split_input.split_type` is `manual`, provide
    /// `split_input.split_definition` (continuous page ranges; `version` may be
    /// omitted or `v_1`). When `split_input.split_type` is `page_selection`,
    /// provide `split_input.page_selection` (non-linear page segments; `version`
    /// may be omitted or `v_2`). `split_input.prompt` must not be provided for
    /// either of those variants. When `split_input.split_type` is `smart`,
    /// `split_input.prompt` is required and neither
    /// `split_input.split_definition` nor `split_input.page_selection` must be
    /// provided.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createDocumentSplitV2026R0 method
    ///   - headers: Headers of createDocumentSplitV2026R0 method
    /// - Returns: The `DocumentSplitCreateResponseV2026R0`.
    /// - Throws: The `GeneralError`.
    public func createDocumentSplitV2026R0(requestBody: DocumentSplitCreateRequestV2026R0, headers: CreateDocumentSplitV2026R0Headers = CreateDocumentSplitV2026R0Headers()) async throws -> DocumentSplitCreateResponseV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/document_splits")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocumentSplitCreateResponseV2026R0.deserialize(from: response.data!)
    }

    /// Returns a paginated list of Document Split jobs accessible to the
    /// authenticated user.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getDocumentSplitsV2026R0 method
    ///   - headers: Headers of getDocumentSplitsV2026R0 method
    /// - Returns: The `DocumentSplitsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getDocumentSplitsV2026R0(queryParams: GetDocumentSplitsV2026R0QueryParams = GetDocumentSplitsV2026R0QueryParams(), headers: GetDocumentSplitsV2026R0Headers = GetDocumentSplitsV2026R0Headers()) async throws -> DocumentSplitsV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/document_splits")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocumentSplitsV2026R0.deserialize(from: response.data!)
    }

    /// Returns details for a single Document Split job identified by its ID,
    /// including the current status, the input definition, and any output files
    /// produced by the job.
    ///
    /// - Parameters:
    ///   - documentSplitId: The unique identifier for the Document Split job.
    ///     Example: "1748426"
    ///   - headers: Headers of getDocumentSplitByIdV2026R0 method
    /// - Returns: The `DocumentSplitV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getDocumentSplitByIdV2026R0(documentSplitId: String, headers: GetDocumentSplitByIdV2026R0Headers = GetDocumentSplitByIdV2026R0Headers()) async throws -> DocumentSplitV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/document_splits/")\(Utils.Strings.toString(value: documentSplitId)!)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try DocumentSplitV2026R0.deserialize(from: response.data!)
    }

}
