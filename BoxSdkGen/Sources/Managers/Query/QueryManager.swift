import Foundation

public class QueryManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Runs a query to discover Box items using a logical predicate, similar to a SQL
    /// WHERE clause. The predicate can filter across multiple metadata templates and
    /// item fields in a single request. Results can be sorted, paginated with markers,
    /// and shaped with fields so each entry includes additional item or metadata
    /// attributes.
    /// 
    /// This is the item-retrieval endpoint in the Query API (version 2026.0). Unlike
    /// the [Metadata Query API](https://developer.box.com/reference/post-metadata-queries-execute-read),
    /// it is not limited to a single metadata template or to files and folders. For
    /// totals and grouped metrics over the same predicates, use
    /// [Query Insights](https://developer.box.com/reference/v2026.0/post-query-insights)
    /// instead of paging through every matching item.
    /// 
    /// For predicate syntax, parameters, examples, pagination behavior, and error
    /// codes, see the
    /// [Box Query guide](https://developer.box.com/guides/query/box-query). For shared
    /// response schemas, including Query results and result entries, see
    /// [Query resources](https://developer.box.com/reference/v2026.0/query-resources).
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createQueryV2026R0 method
    ///   - headers: Headers of createQueryV2026R0 method
    /// - Returns: The `QueryResultsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func createQueryV2026R0(requestBody: QueryRequestBodyV2026R0, headers: CreateQueryV2026R0Headers = CreateQueryV2026R0Headers()) async throws -> QueryResultsV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/query")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try QueryResultsV2026R0.deserialize(from: response.data!)
    }

    /// Computes aggregated metrics over Box items matching a query predicate.
    /// Filters are applied first, followed by optional grouping, after which the
    /// requested metrics (such as `sum`, `avg`, `min`, `max`, and `count`) are
    /// computed for each resulting group or over the entire filtered dataset.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createQueryInsightV2026R0 method
    ///   - headers: Headers of createQueryInsightV2026R0 method
    /// - Returns: The `QueryInsightsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func createQueryInsightV2026R0(requestBody: QueryInsightsRequestBodyV2026R0, headers: CreateQueryInsightV2026R0Headers = CreateQueryInsightV2026R0Headers()) async throws -> QueryInsightsV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/query_insights")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try QueryInsightsV2026R0.deserialize(from: response.data!)
    }

}
