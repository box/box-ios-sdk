import Foundation

public class SearchManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Create a search using SQL-like syntax to return items that match specific
    /// metadata.
    /// 
    /// By default, this endpoint returns only the most basic info about the items for
    /// which the query matches. To get additional fields for each item, including any
    /// of the metadata, use the `fields` attribute in the query.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of searchByMetadataQuery method
    ///   - headers: Headers of searchByMetadataQuery method
    /// - Returns: The `MetadataQueryResults`.
    /// - Throws: The `GeneralError`.
    public func searchByMetadataQuery(requestBody: MetadataQuery, headers: SearchByMetadataQueryHeaders = SearchByMetadataQueryHeaders()) async throws -> MetadataQueryResults {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_queries/execute_read")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataQueryResults.deserialize(from: response.data!)
    }

    /// Searches for files, folders, web links, and shared files across the
    /// users content or across the entire enterprise.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of searchForContent method
    ///   - headers: Headers of searchForContent method
    /// - Returns: The `SearchResultsOrSearchResultsWithSharedLinks`.
    /// - Throws: The `GeneralError`.
    public func searchForContent(queryParams: SearchForContentQueryParams = SearchForContentQueryParams(), headers: SearchForContentHeaders = SearchForContentHeaders()) async throws -> SearchResultsOrSearchResultsWithSharedLinks {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["query": Utils.Strings.toString(value: queryParams.query), "scope": Utils.Strings.toString(value: queryParams.scope), "file_extensions": Utils.Strings.toString(value: queryParams.fileExtensions), "created_at_range": Utils.Strings.toString(value: queryParams.createdAtRange), "updated_at_range": Utils.Strings.toString(value: queryParams.updatedAtRange), "size_range": Utils.Strings.toString(value: queryParams.sizeRange), "owner_user_ids": Utils.Strings.toString(value: queryParams.ownerUserIds), "recent_updater_user_ids": Utils.Strings.toString(value: queryParams.recentUpdaterUserIds), "ancestor_folder_ids": Utils.Strings.toString(value: queryParams.ancestorFolderIds), "content_types": Utils.Strings.toString(value: queryParams.contentTypes), "type": Utils.Strings.toString(value: queryParams.type), "trash_content": Utils.Strings.toString(value: queryParams.trashContent), "mdfilters": Utils.Strings.toString(value: queryParams.mdfilters), "sort": Utils.Strings.toString(value: queryParams.sort), "direction": Utils.Strings.toString(value: queryParams.direction), "limit": Utils.Strings.toString(value: queryParams.limit), "include_recent_shared_links": Utils.Strings.toString(value: queryParams.includeRecentSharedLinks), "fields": Utils.Strings.toString(value: queryParams.fields), "offset": Utils.Strings.toString(value: queryParams.offset), "deleted_user_ids": Utils.Strings.toString(value: queryParams.deletedUserIds), "deleted_at_range": Utils.Strings.toString(value: queryParams.deletedAtRange)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/search")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try SearchResultsOrSearchResultsWithSharedLinks.deserialize(from: response.data!)
    }

}
