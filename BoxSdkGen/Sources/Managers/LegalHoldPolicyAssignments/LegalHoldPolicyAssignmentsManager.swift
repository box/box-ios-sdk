import Foundation

public class LegalHoldPolicyAssignmentsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves a list of items a legal hold policy has been assigned to.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getLegalHoldPolicyAssignments method
    ///   - headers: Headers of getLegalHoldPolicyAssignments method
    /// - Returns: The `LegalHoldPolicyAssignments`.
    /// - Throws: The `GeneralError`.
    public func getLegalHoldPolicyAssignments(queryParams: GetLegalHoldPolicyAssignmentsQueryParams, headers: GetLegalHoldPolicyAssignmentsHeaders = GetLegalHoldPolicyAssignmentsHeaders()) async throws -> LegalHoldPolicyAssignments {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["policy_id": Utils.Strings.toString(value: queryParams.policyId), "assign_to_type": Utils.Strings.toString(value: queryParams.assignToType), "assign_to_id": Utils.Strings.toString(value: queryParams.assignToId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit), "fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/legal_hold_policy_assignments")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try LegalHoldPolicyAssignments.deserialize(from: response.data!)
    }

    /// Assign a legal hold to a file, file version, folder, or user.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createLegalHoldPolicyAssignment method
    ///   - headers: Headers of createLegalHoldPolicyAssignment method
    /// - Returns: The `LegalHoldPolicyAssignment`.
    /// - Throws: The `GeneralError`.
    public func createLegalHoldPolicyAssignment(requestBody: CreateLegalHoldPolicyAssignmentRequestBody, headers: CreateLegalHoldPolicyAssignmentHeaders = CreateLegalHoldPolicyAssignmentHeaders()) async throws -> LegalHoldPolicyAssignment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/legal_hold_policy_assignments")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try LegalHoldPolicyAssignment.deserialize(from: response.data!)
    }

    /// Retrieve a legal hold policy assignment.
    ///
    /// - Parameters:
    ///   - legalHoldPolicyAssignmentId: The ID of the legal hold policy assignment
    ///     Example: "753465"
    ///   - headers: Headers of getLegalHoldPolicyAssignmentById method
    /// - Returns: The `LegalHoldPolicyAssignment`.
    /// - Throws: The `GeneralError`.
    public func getLegalHoldPolicyAssignmentById(legalHoldPolicyAssignmentId: String, headers: GetLegalHoldPolicyAssignmentByIdHeaders = GetLegalHoldPolicyAssignmentByIdHeaders()) async throws -> LegalHoldPolicyAssignment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/legal_hold_policy_assignments/")\(legalHoldPolicyAssignmentId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try LegalHoldPolicyAssignment.deserialize(from: response.data!)
    }

    /// Remove a legal hold from an item.
    /// 
    /// This is an asynchronous process. The policy will not be
    /// fully removed yet when the response returns.
    ///
    /// - Parameters:
    ///   - legalHoldPolicyAssignmentId: The ID of the legal hold policy assignment
    ///     Example: "753465"
    ///   - headers: Headers of deleteLegalHoldPolicyAssignmentById method
    /// - Throws: The `GeneralError`.
    public func deleteLegalHoldPolicyAssignmentById(legalHoldPolicyAssignmentId: String, headers: DeleteLegalHoldPolicyAssignmentByIdHeaders = DeleteLegalHoldPolicyAssignmentByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/legal_hold_policy_assignments/")\(legalHoldPolicyAssignmentId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Get a list of files with current file versions for a legal hold
    /// assignment.
    /// 
    /// In some cases you may want to get previous file versions instead. In these
    /// cases, use the `GET  /legal_hold_policy_assignments/:id/file_versions_on_hold`
    /// API instead to return any previous versions of a file for this legal hold
    /// policy assignment.
    /// 
    /// Due to ongoing re-architecture efforts this API might not return all file
    /// versions held for this policy ID. Instead, this API will only return the
    /// latest file version held in the newly developed architecture. The `GET
    /// /file_version_legal_holds` API can be used to fetch current and past versions
    /// of files held within the legacy architecture.
    /// 
    /// This endpoint does not support returning any content that is on hold due to
    /// a Custodian collaborating on a Hub.
    /// 
    /// The `GET /legal_hold_policy_assignments?policy_id={id}` API can be used to
    /// find a list of policy assignments for a given policy ID.
    ///
    /// - Parameters:
    ///   - legalHoldPolicyAssignmentId: The ID of the legal hold policy assignment
    ///     Example: "753465"
    ///   - queryParams: Query parameters of getLegalHoldPolicyAssignmentFileOnHold method
    ///   - headers: Headers of getLegalHoldPolicyAssignmentFileOnHold method
    /// - Returns: The `FilesOnHold`.
    /// - Throws: The `GeneralError`.
    public func getLegalHoldPolicyAssignmentFileOnHold(legalHoldPolicyAssignmentId: String, queryParams: GetLegalHoldPolicyAssignmentFileOnHoldQueryParams = GetLegalHoldPolicyAssignmentFileOnHoldQueryParams(), headers: GetLegalHoldPolicyAssignmentFileOnHoldHeaders = GetLegalHoldPolicyAssignmentFileOnHoldHeaders()) async throws -> FilesOnHold {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit), "fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/legal_hold_policy_assignments/")\(legalHoldPolicyAssignmentId)\("/files_on_hold")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FilesOnHold.deserialize(from: response.data!)
    }

}
