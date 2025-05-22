import Foundation

public class FileVersionLegalHoldsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves information about the legal hold policies
    /// assigned to a file version.
    ///
    /// - Parameters:
    ///   - fileVersionLegalHoldId: The ID of the file version legal hold
    ///     Example: "2348213"
    ///   - headers: Headers of getFileVersionLegalHoldById method
    /// - Returns: The `FileVersionLegalHold`.
    /// - Throws: The `GeneralError`.
    public func getFileVersionLegalHoldById(fileVersionLegalHoldId: String, headers: GetFileVersionLegalHoldByIdHeaders = GetFileVersionLegalHoldByIdHeaders()) async throws -> FileVersionLegalHold {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/file_version_legal_holds/")\(fileVersionLegalHoldId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileVersionLegalHold.deserialize(from: response.data!)
    }

    /// Get a list of file versions on legal hold for a legal hold
    /// assignment.
    /// 
    /// Due to ongoing re-architecture efforts this API might not return all file
    /// versions for this policy ID.
    /// 
    /// Instead, this API will only return file versions held in the legacy
    /// architecture. Two new endpoints will available to request any file versions
    /// held in the new architecture.
    /// 
    /// For file versions held in the new architecture, the `GET
    /// /legal_hold_policy_assignments/:id/file_versions_on_hold` API can be used to
    /// return all past file versions available for this policy assignment, and the
    /// `GET /legal_hold_policy_assignments/:id/files_on_hold` API can be used to
    /// return any current (latest) versions of a file under legal hold.
    /// 
    /// The `GET /legal_hold_policy_assignments?policy_id={id}` API can be used to
    /// find a list of policy assignments for a given policy ID.
    /// 
    /// Once the re-architecture is completed this API will be deprecated.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getFileVersionLegalHolds method
    ///   - headers: Headers of getFileVersionLegalHolds method
    /// - Returns: The `FileVersionLegalHolds`.
    /// - Throws: The `GeneralError`.
    public func getFileVersionLegalHolds(queryParams: GetFileVersionLegalHoldsQueryParams, headers: GetFileVersionLegalHoldsHeaders = GetFileVersionLegalHoldsHeaders()) async throws -> FileVersionLegalHolds {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["policy_id": Utils.Strings.toString(value: queryParams.policyId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/file_version_legal_holds")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FileVersionLegalHolds.deserialize(from: response.data!)
    }

}
