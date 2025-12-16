import Foundation

public class GetMetadataTaxonomyNodesQueryParams {
    /// Filters results by taxonomy level. Multiple values can be provided. 
    /// Results include nodes that match any of the specified values.
    public let level: [Int64]?

    /// Node identifier of a direct parent node. Multiple values can be provided. 
    /// Results include nodes that match any of the specified values.
    public let parent: [String]?

    /// Node identifier of any ancestor node. Multiple values can be provided. 
    /// Results include nodes that match any of the specified values.
    public let ancestor: [String]?

    /// Query text to search for the taxonomy nodes.
    public let query: String?

    /// When set to `true` this provides the total number of nodes that matched the query. 
    /// The response will compute counts of up to 10,000 elements. Defaults to `false`.
    public let includeTotalResultCount: Bool?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetMetadataTaxonomyNodesQueryParams.
    ///
    /// - Parameters:
    ///   - level: Filters results by taxonomy level. Multiple values can be provided. 
    ///     Results include nodes that match any of the specified values.
    ///   - parent: Node identifier of a direct parent node. Multiple values can be provided. 
    ///     Results include nodes that match any of the specified values.
    ///   - ancestor: Node identifier of any ancestor node. Multiple values can be provided. 
    ///     Results include nodes that match any of the specified values.
    ///   - query: Query text to search for the taxonomy nodes.
    ///   - includeTotalResultCount: When set to `true` this provides the total number of nodes that matched the query. 
    ///     The response will compute counts of up to 10,000 elements. Defaults to `false`.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(level: [Int64]? = nil, parent: [String]? = nil, ancestor: [String]? = nil, query: String? = nil, includeTotalResultCount: Bool? = nil, marker: String? = nil, limit: Int64? = nil) {
        self.level = level
        self.parent = parent
        self.ancestor = ancestor
        self.query = query
        self.includeTotalResultCount = includeTotalResultCount
        self.marker = marker
        self.limit = limit
    }

}
