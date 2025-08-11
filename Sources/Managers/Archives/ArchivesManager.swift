import Foundation

public class ArchivesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves archives for an enterprise.
    /// 
    /// To learn more about the archive APIs, see the [Archive API Guide](g://archives).
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getArchivesV2025R0 method
    ///   - headers: Headers of getArchivesV2025R0 method
    /// - Returns: The `ArchivesV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getArchivesV2025R0(queryParams: GetArchivesV2025R0QueryParams = GetArchivesV2025R0QueryParams(), headers: GetArchivesV2025R0Headers = GetArchivesV2025R0Headers()) async throws -> ArchivesV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["limit": Utils.Strings.toString(value: queryParams.limit), "marker": Utils.Strings.toString(value: queryParams.marker)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/archives")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ArchivesV2025R0.deserialize(from: response.data!)
    }

    /// Creates an archive.
    /// 
    /// To learn more about the archive APIs, see the [Archive API Guide](g://archives).
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createArchiveV2025R0 method
    ///   - headers: Headers of createArchiveV2025R0 method
    /// - Returns: The `ArchiveV2025R0`.
    /// - Throws: The `GeneralError`.
    public func createArchiveV2025R0(requestBody: CreateArchiveV2025R0RequestBody, headers: CreateArchiveV2025R0Headers = CreateArchiveV2025R0Headers()) async throws -> ArchiveV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/archives")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ArchiveV2025R0.deserialize(from: response.data!)
    }

    /// Permanently deletes an archive.
    /// 
    /// To learn more about the archive APIs, see the [Archive API Guide](g://archives).
    ///
    /// - Parameters:
    ///   - archiveId: The ID of the archive.
    ///     Example: "982312"
    ///   - headers: Headers of deleteArchiveByIdV2025R0 method
    /// - Throws: The `GeneralError`.
    public func deleteArchiveByIdV2025R0(archiveId: String, headers: DeleteArchiveByIdV2025R0Headers = DeleteArchiveByIdV2025R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/archives/")\(archiveId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
