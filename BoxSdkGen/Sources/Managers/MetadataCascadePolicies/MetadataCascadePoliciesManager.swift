import Foundation

public class MetadataCascadePoliciesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves a list of all the metadata cascade policies
    /// that are applied to a given folder. This can not be used on the root
    /// folder with ID `0`.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getMetadataCascadePolicies method
    ///   - headers: Headers of getMetadataCascadePolicies method
    /// - Returns: The `MetadataCascadePolicies`.
    /// - Throws: The `GeneralError`.
    public func getMetadataCascadePolicies(queryParams: GetMetadataCascadePoliciesQueryParams, headers: GetMetadataCascadePoliciesHeaders = GetMetadataCascadePoliciesHeaders()) async throws -> MetadataCascadePolicies {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["folder_id": Utils.Strings.toString(value: queryParams.folderId), "owner_enterprise_id": Utils.Strings.toString(value: queryParams.ownerEnterpriseId), "marker": Utils.Strings.toString(value: queryParams.marker), "offset": Utils.Strings.toString(value: queryParams.offset)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_cascade_policies")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataCascadePolicies.deserialize(from: response.data!)
    }

    /// Creates a new metadata cascade policy that applies a given
    /// metadata template to a given folder and automatically
    /// cascades it down to any files within that folder.
    /// 
    /// In order for the policy to be applied a metadata instance must first
    /// be applied to the folder the policy is to be applied to.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createMetadataCascadePolicy method
    ///   - headers: Headers of createMetadataCascadePolicy method
    /// - Returns: The `MetadataCascadePolicy`.
    /// - Throws: The `GeneralError`.
    public func createMetadataCascadePolicy(requestBody: CreateMetadataCascadePolicyRequestBody, headers: CreateMetadataCascadePolicyHeaders = CreateMetadataCascadePolicyHeaders()) async throws -> MetadataCascadePolicy {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_cascade_policies")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataCascadePolicy.deserialize(from: response.data!)
    }

    /// Retrieve a specific metadata cascade policy assigned to a folder.
    ///
    /// - Parameters:
    ///   - metadataCascadePolicyId: The ID of the metadata cascade policy.
    ///     Example: "6fd4ff89-8fc1-42cf-8b29-1890dedd26d7"
    ///   - headers: Headers of getMetadataCascadePolicyById method
    /// - Returns: The `MetadataCascadePolicy`.
    /// - Throws: The `GeneralError`.
    public func getMetadataCascadePolicyById(metadataCascadePolicyId: String, headers: GetMetadataCascadePolicyByIdHeaders = GetMetadataCascadePolicyByIdHeaders()) async throws -> MetadataCascadePolicy {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_cascade_policies/")\(metadataCascadePolicyId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try MetadataCascadePolicy.deserialize(from: response.data!)
    }

    /// Deletes a metadata cascade policy.
    ///
    /// - Parameters:
    ///   - metadataCascadePolicyId: The ID of the metadata cascade policy.
    ///     Example: "6fd4ff89-8fc1-42cf-8b29-1890dedd26d7"
    ///   - headers: Headers of deleteMetadataCascadePolicyById method
    /// - Throws: The `GeneralError`.
    public func deleteMetadataCascadePolicyById(metadataCascadePolicyId: String, headers: DeleteMetadataCascadePolicyByIdHeaders = DeleteMetadataCascadePolicyByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_cascade_policies/")\(metadataCascadePolicyId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Force the metadata on a folder with a metadata cascade policy to be applied to
    /// all of its children. This can be used after creating a new cascade policy to
    /// enforce the metadata to be cascaded down to all existing files within that
    /// folder.
    ///
    /// - Parameters:
    ///   - metadataCascadePolicyId: The ID of the cascade policy to force-apply.
    ///     Example: "6fd4ff89-8fc1-42cf-8b29-1890dedd26d7"
    ///   - requestBody: Request body of applyMetadataCascadePolicy method
    ///   - headers: Headers of applyMetadataCascadePolicy method
    /// - Throws: The `GeneralError`.
    public func applyMetadataCascadePolicy(metadataCascadePolicyId: String, requestBody: ApplyMetadataCascadePolicyRequestBody, headers: ApplyMetadataCascadePolicyHeaders = ApplyMetadataCascadePolicyHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/metadata_cascade_policies/")\(metadataCascadePolicyId)\("/apply")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
