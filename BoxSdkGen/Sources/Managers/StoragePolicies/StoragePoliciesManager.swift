import Foundation

public class StoragePoliciesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Fetches all the storage policies in the enterprise.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getStoragePolicies method
    ///   - headers: Headers of getStoragePolicies method
    /// - Returns: The `StoragePolicies`.
    /// - Throws: The `GeneralError`.
    public func getStoragePolicies(queryParams: GetStoragePoliciesQueryParams = GetStoragePoliciesQueryParams(), headers: GetStoragePoliciesHeaders = GetStoragePoliciesHeaders()) async throws -> StoragePolicies {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/storage_policies")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try StoragePolicies.deserialize(from: response.data!)
    }

    /// Fetches a specific storage policy.
    ///
    /// - Parameters:
    ///   - storagePolicyId: The ID of the storage policy.
    ///     Example: "34342"
    ///   - headers: Headers of getStoragePolicyById method
    /// - Returns: The `StoragePolicy`.
    /// - Throws: The `GeneralError`.
    public func getStoragePolicyById(storagePolicyId: String, headers: GetStoragePolicyByIdHeaders = GetStoragePolicyByIdHeaders()) async throws -> StoragePolicy {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/storage_policies/")\(storagePolicyId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try StoragePolicy.deserialize(from: response.data!)
    }

}
