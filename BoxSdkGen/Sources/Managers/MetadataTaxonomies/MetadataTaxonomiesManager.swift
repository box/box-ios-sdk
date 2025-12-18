import Foundation

public class MetadataTaxonomiesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Creates a new metadata taxonomy that can be used in
    /// metadata templates.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createMetadataTaxonomy method
    ///   - headers: Headers of createMetadataTaxonomy method
    /// - Returns: The `MetadataTaxonomy`.
    /// - Throws: The `GeneralError`.
    public func createMetadataTaxonomy(requestBody: CreateMetadataTaxonomyRequestBody, headers: CreateMetadataTaxonomyHeaders = CreateMetadataTaxonomyHeaders()) async throws -> MetadataTaxonomy {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomy.deserialize(from: response.data!)
    }

    /// Used to retrieve all metadata taxonomies in a namespace.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - queryParams: Query parameters of getMetadataTaxonomies method
    ///   - headers: Headers of getMetadataTaxonomies method
    /// - Returns: The `MetadataTaxonomies`.
    /// - Throws: The `GeneralError`.
    public func getMetadataTaxonomies(namespace: String, queryParams: GetMetadataTaxonomiesQueryParams = GetMetadataTaxonomiesQueryParams(), headers: GetMetadataTaxonomiesHeaders = GetMetadataTaxonomiesHeaders()) async throws -> MetadataTaxonomies {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomies.deserialize(from: response.data!)
    }

    /// Used to retrieve a metadata taxonomy by taxonomy key.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - headers: Headers of getMetadataTaxonomyByKey method
    /// - Returns: The `MetadataTaxonomy`.
    /// - Throws: The `GeneralError`.
    public func getMetadataTaxonomyByKey(namespace: String, taxonomyKey: String, headers: GetMetadataTaxonomyByKeyHeaders = GetMetadataTaxonomyByKeyHeaders()) async throws -> MetadataTaxonomy {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomy.deserialize(from: response.data!)
    }

    /// Updates an existing metadata taxonomy.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - requestBody: Request body of updateMetadataTaxonomy method
    ///   - headers: Headers of updateMetadataTaxonomy method
    /// - Returns: The `MetadataTaxonomy`.
    /// - Throws: The `GeneralError`.
    public func updateMetadataTaxonomy(namespace: String, taxonomyKey: String, requestBody: UpdateMetadataTaxonomyRequestBody, headers: UpdateMetadataTaxonomyHeaders = UpdateMetadataTaxonomyHeaders()) async throws -> MetadataTaxonomy {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)", method: "PATCH", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomy.deserialize(from: response.data!)
    }

    /// Delete a metadata taxonomy.
    /// This deletion is permanent and cannot be reverted.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - headers: Headers of deleteMetadataTaxonomy method
    /// - Throws: The `GeneralError`.
    public func deleteMetadataTaxonomy(namespace: String, taxonomyKey: String, headers: DeleteMetadataTaxonomyHeaders = DeleteMetadataTaxonomyHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Creates new metadata taxonomy levels.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - requestBody: Request body of createMetadataTaxonomyLevel method
    ///   - headers: Headers of createMetadataTaxonomyLevel method
    /// - Returns: The `MetadataTaxonomyLevels`.
    /// - Throws: The `GeneralError`.
    public func createMetadataTaxonomyLevel(namespace: String, taxonomyKey: String, requestBody: [MetadataTaxonomyLevel], headers: CreateMetadataTaxonomyLevelHeaders = CreateMetadataTaxonomyLevelHeaders()) async throws -> MetadataTaxonomyLevels {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)\("/levels")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomyLevels.deserialize(from: response.data!)
    }

    /// Updates an existing metadata taxonomy level.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - levelIndex: The index of the metadata taxonomy level.
    ///     Example: 1
    ///   - requestBody: Request body of updateMetadataTaxonomyLevelById method
    ///   - headers: Headers of updateMetadataTaxonomyLevelById method
    /// - Returns: The `MetadataTaxonomyLevel`.
    /// - Throws: The `GeneralError`.
    public func updateMetadataTaxonomyLevelById(namespace: String, taxonomyKey: String, levelIndex: Int64, requestBody: UpdateMetadataTaxonomyLevelByIdRequestBody, headers: UpdateMetadataTaxonomyLevelByIdHeaders = UpdateMetadataTaxonomyLevelByIdHeaders()) async throws -> MetadataTaxonomyLevel {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)\("/levels/")\(Utils.Strings.toString(value: levelIndex)!)", method: "PATCH", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomyLevel.deserialize(from: response.data!)
    }

    /// Creates a new metadata taxonomy level and appends it to the existing levels.
    /// If there are no levels defined yet, this will create the first level.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - requestBody: Request body of addMetadataTaxonomyLevel method
    ///   - headers: Headers of addMetadataTaxonomyLevel method
    /// - Returns: The `MetadataTaxonomyLevels`.
    /// - Throws: The `GeneralError`.
    public func addMetadataTaxonomyLevel(namespace: String, taxonomyKey: String, requestBody: AddMetadataTaxonomyLevelRequestBody, headers: AddMetadataTaxonomyLevelHeaders = AddMetadataTaxonomyLevelHeaders()) async throws -> MetadataTaxonomyLevels {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)\("/levels:append")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomyLevels.deserialize(from: response.data!)
    }

    /// Deletes the last level of the metadata taxonomy.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - headers: Headers of deleteMetadataTaxonomyLevel method
    /// - Returns: The `MetadataTaxonomyLevels`.
    /// - Throws: The `GeneralError`.
    public func deleteMetadataTaxonomyLevel(namespace: String, taxonomyKey: String, headers: DeleteMetadataTaxonomyLevelHeaders = DeleteMetadataTaxonomyLevelHeaders()) async throws -> MetadataTaxonomyLevels {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)\("/levels:trim")", method: "POST", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomyLevels.deserialize(from: response.data!)
    }

    /// Used to retrieve metadata taxonomy nodes based on the parameters specified. 
    /// Results are sorted in lexicographic order unless a `query` parameter is passed. 
    /// With a `query` parameter specified, results are sorted in order of relevance.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - queryParams: Query parameters of getMetadataTaxonomyNodes method
    ///   - headers: Headers of getMetadataTaxonomyNodes method
    /// - Returns: The `MetadataTaxonomyNodes`.
    /// - Throws: The `GeneralError`.
    public func getMetadataTaxonomyNodes(namespace: String, taxonomyKey: String, queryParams: GetMetadataTaxonomyNodesQueryParams = GetMetadataTaxonomyNodesQueryParams(), headers: GetMetadataTaxonomyNodesHeaders = GetMetadataTaxonomyNodesHeaders()) async throws -> MetadataTaxonomyNodes {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["level": Utils.Strings.toString(value: queryParams.level), "parent": Utils.Strings.toString(value: queryParams.parent), "ancestor": Utils.Strings.toString(value: queryParams.ancestor), "query": Utils.Strings.toString(value: queryParams.query), "include-total-result-count": Utils.Strings.toString(value: queryParams.includeTotalResultCount), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)\("/nodes")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomyNodes.deserialize(from: response.data!)
    }

    /// Creates a new metadata taxonomy node.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - requestBody: Request body of createMetadataTaxonomyNode method
    ///   - headers: Headers of createMetadataTaxonomyNode method
    /// - Returns: The `MetadataTaxonomyNode`.
    /// - Throws: The `GeneralError`.
    public func createMetadataTaxonomyNode(namespace: String, taxonomyKey: String, requestBody: CreateMetadataTaxonomyNodeRequestBody, headers: CreateMetadataTaxonomyNodeHeaders = CreateMetadataTaxonomyNodeHeaders()) async throws -> MetadataTaxonomyNode {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)\("/nodes")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomyNode.deserialize(from: response.data!)
    }

    /// Retrieves a metadata taxonomy node by its identifier.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - nodeId: The identifier of the metadata taxonomy node.
    ///     Example: "14d3d433-c77f-49c5-b146-9dea370f6e32"
    ///   - headers: Headers of getMetadataTaxonomyNodeById method
    /// - Returns: The `MetadataTaxonomyNode`.
    /// - Throws: The `GeneralError`.
    public func getMetadataTaxonomyNodeById(namespace: String, taxonomyKey: String, nodeId: String, headers: GetMetadataTaxonomyNodeByIdHeaders = GetMetadataTaxonomyNodeByIdHeaders()) async throws -> MetadataTaxonomyNode {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)\("/nodes/")\(Utils.Strings.toString(value: nodeId)!)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomyNode.deserialize(from: response.data!)
    }

    /// Updates an existing metadata taxonomy node.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - nodeId: The identifier of the metadata taxonomy node.
    ///     Example: "14d3d433-c77f-49c5-b146-9dea370f6e32"
    ///   - requestBody: Request body of updateMetadataTaxonomyNode method
    ///   - headers: Headers of updateMetadataTaxonomyNode method
    /// - Returns: The `MetadataTaxonomyNode`.
    /// - Throws: The `GeneralError`.
    public func updateMetadataTaxonomyNode(namespace: String, taxonomyKey: String, nodeId: String, requestBody: UpdateMetadataTaxonomyNodeRequestBody = UpdateMetadataTaxonomyNodeRequestBody(), headers: UpdateMetadataTaxonomyNodeHeaders = UpdateMetadataTaxonomyNodeHeaders()) async throws -> MetadataTaxonomyNode {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)\("/nodes/")\(Utils.Strings.toString(value: nodeId)!)", method: "PATCH", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomyNode.deserialize(from: response.data!)
    }

    /// Delete a metadata taxonomy node.
    /// This deletion is permanent and cannot be reverted.
    /// Only metadata taxonomy nodes without any children can be deleted.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - taxonomyKey: The key of the metadata taxonomy.
    ///     Example: "geography"
    ///   - nodeId: The identifier of the metadata taxonomy node.
    ///     Example: "14d3d433-c77f-49c5-b146-9dea370f6e32"
    ///   - headers: Headers of deleteMetadataTaxonomyNode method
    /// - Throws: The `GeneralError`.
    public func deleteMetadataTaxonomyNode(namespace: String, taxonomyKey: String, nodeId: String, headers: DeleteMetadataTaxonomyNodeHeaders = DeleteMetadataTaxonomyNodeHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_taxonomies/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: taxonomyKey)!)\("/nodes/")\(Utils.Strings.toString(value: nodeId)!)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Used to retrieve metadata taxonomy nodes which are available for the taxonomy field based 
    /// on its configuration and the parameters specified. 
    /// Results are sorted in lexicographic order unless a `query` parameter is passed. 
    /// With a `query` parameter specified, results are sorted in order of relevance.
    ///
    /// - Parameters:
    ///   - namespace: The namespace of the metadata taxonomy.
    ///     Example: "enterprise_123456"
    ///   - templateKey: The name of the metadata template.
    ///     Example: "properties"
    ///   - fieldKey: The key of the metadata taxonomy field in the template.
    ///     Example: "geography"
    ///   - queryParams: Query parameters of getMetadataTemplateFieldOptions method
    ///   - headers: Headers of getMetadataTemplateFieldOptions method
    /// - Returns: The `MetadataTaxonomyNodes`.
    /// - Throws: The `GeneralError`.
    public func getMetadataTemplateFieldOptions(namespace: String, templateKey: String, fieldKey: String, queryParams: GetMetadataTemplateFieldOptionsQueryParams = GetMetadataTemplateFieldOptionsQueryParams(), headers: GetMetadataTemplateFieldOptionsHeaders = GetMetadataTemplateFieldOptionsHeaders()) async throws -> MetadataTaxonomyNodes {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["level": Utils.Strings.toString(value: queryParams.level), "parent": Utils.Strings.toString(value: queryParams.parent), "ancestor": Utils.Strings.toString(value: queryParams.ancestor), "query": Utils.Strings.toString(value: queryParams.query), "include-total-result-count": Utils.Strings.toString(value: queryParams.includeTotalResultCount), "only-selectable-options": Utils.Strings.toString(value: queryParams.onlySelectableOptions), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_templates/")\(Utils.Strings.toString(value: namespace)!)\("/")\(Utils.Strings.toString(value: templateKey)!)\("/fields/")\(Utils.Strings.toString(value: fieldKey)!)\("/options")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataTaxonomyNodes.deserialize(from: response.data!)
    }

}
