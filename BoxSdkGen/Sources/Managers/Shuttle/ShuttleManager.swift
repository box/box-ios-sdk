import Foundation

public class ShuttleManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns a paginated list of shuttle systems accessible to the
    /// authenticated user.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShuttleSystemsV2026R0 method
    ///   - headers: Headers of getShuttleSystemsV2026R0 method
    /// - Returns: The `ShuttleSystemsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleSystemsV2026R0(queryParams: GetShuttleSystemsV2026R0QueryParams = GetShuttleSystemsV2026R0QueryParams(), headers: GetShuttleSystemsV2026R0Headers = GetShuttleSystemsV2026R0Headers()) async throws -> ShuttleSystemsV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_systems")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleSystemsV2026R0.deserialize(from: response.data!)
    }

    /// Creates a new shuttle system. Only Windows agent systems can be created
    /// through the public API; other system types must be configured through the
    /// Shuttle application.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShuttleSystemV2026R0 method
    ///   - headers: Headers of createShuttleSystemV2026R0 method
    /// - Returns: The `ShuttleSystemV2026R0`.
    /// - Throws: The `GeneralError`.
    public func createShuttleSystemV2026R0(requestBody: ShuttleSystemCreateRequestV2026R0, headers: CreateShuttleSystemV2026R0Headers = CreateShuttleSystemV2026R0Headers()) async throws -> ShuttleSystemV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_systems")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleSystemV2026R0.deserialize(from: response.data!)
    }

    /// Returns details for a single shuttle system identified by its ID,
    /// including its type and connection state.
    ///
    /// - Parameters:
    ///   - shuttleSystemId: The unique identifier for the shuttle system.
    ///     Example: "6a315c0754833bfc5df067bf"
    ///   - headers: Headers of getShuttleSystemByIdV2026R0 method
    /// - Returns: The `ShuttleSystemV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleSystemByIdV2026R0(shuttleSystemId: String, headers: GetShuttleSystemByIdV2026R0Headers = GetShuttleSystemByIdV2026R0Headers()) async throws -> ShuttleSystemV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_systems/")\(Utils.Strings.toString(value: shuttleSystemId)!)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleSystemV2026R0.deserialize(from: response.data!)
    }

    /// Updates the mutable properties of an existing shuttle system identified by
    /// its ID. Only the fields supplied in the request body are changed.
    ///
    /// - Parameters:
    ///   - shuttleSystemId: The unique identifier for the shuttle system.
    ///     Example: "6a315c0754833bfc5df067bf"
    ///   - requestBody: Request body of updateShuttleSystemByIdV2026R0 method
    ///   - headers: Headers of updateShuttleSystemByIdV2026R0 method
    /// - Returns: The `ShuttleSystemV2026R0`.
    /// - Throws: The `GeneralError`.
    public func updateShuttleSystemByIdV2026R0(shuttleSystemId: String, requestBody: ShuttleSystemUpdateRequestV2026R0, headers: UpdateShuttleSystemByIdV2026R0Headers = UpdateShuttleSystemByIdV2026R0Headers()) async throws -> ShuttleSystemV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_systems/")\(Utils.Strings.toString(value: shuttleSystemId)!)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleSystemV2026R0.deserialize(from: response.data!)
    }

    /// Permanently deletes the shuttle system identified by its ID. This does not
    /// affect content that has already been migrated.
    ///
    /// - Parameters:
    ///   - shuttleSystemId: The unique identifier for the shuttle system.
    ///     Example: "6a315c0754833bfc5df067bf"
    ///   - headers: Headers of deleteShuttleSystemByIdV2026R0 method
    /// - Throws: The `GeneralError`.
    public func deleteShuttleSystemByIdV2026R0(shuttleSystemId: String, headers: DeleteShuttleSystemByIdV2026R0Headers = DeleteShuttleSystemByIdV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_systems/")\(Utils.Strings.toString(value: shuttleSystemId)!)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Issues a new installation token for the Windows shuttle system identified
    /// by its ID. Paste the returned token into the Windows agent installer to
    /// register the agent with this system.
    ///
    /// - Parameters:
    ///   - shuttleSystemId: The unique identifier for the shuttle system.
    ///     Example: "6a315c0754833bfc5df067bf"
    ///   - headers: Headers of createShuttleSystemIssueRegistrationTokenV2026R0 method
    /// - Returns: The `ShuttleAgentCredentialsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func createShuttleSystemIssueRegistrationTokenV2026R0(shuttleSystemId: String, headers: CreateShuttleSystemIssueRegistrationTokenV2026R0Headers = CreateShuttleSystemIssueRegistrationTokenV2026R0Headers()) async throws -> ShuttleAgentCredentialsV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_systems/")\(Utils.Strings.toString(value: shuttleSystemId)!)\("/issue_registration_token")", method: "POST", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleAgentCredentialsV2026R0.deserialize(from: response.data!)
    }

    /// Returns a paginated list of shuttle jobs accessible to the authenticated
    /// user.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShuttleJobsV2026R0 method
    ///   - headers: Headers of getShuttleJobsV2026R0 method
    /// - Returns: The `ShuttleJobsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleJobsV2026R0(queryParams: GetShuttleJobsV2026R0QueryParams = GetShuttleJobsV2026R0QueryParams(), headers: GetShuttleJobsV2026R0Headers = GetShuttleJobsV2026R0Headers()) async throws -> ShuttleJobsV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_jobs")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleJobsV2026R0.deserialize(from: response.data!)
    }

    /// Creates a new shuttle job that describes a migration from the given source
    /// system into Box.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShuttleJobV2026R0 method
    ///   - headers: Headers of createShuttleJobV2026R0 method
    /// - Returns: The `ShuttleJobV2026R0`.
    /// - Throws: The `GeneralError`.
    public func createShuttleJobV2026R0(requestBody: ShuttleJobCreateRequestV2026R0, headers: CreateShuttleJobV2026R0Headers = CreateShuttleJobV2026R0Headers()) async throws -> ShuttleJobV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_jobs")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleJobV2026R0.deserialize(from: response.data!)
    }

    /// Returns details for a single shuttle job identified by its ID, including
    /// its current state, mapping-preparation state, and configured source system.
    ///
    /// - Parameters:
    ///   - shuttleJobId: The unique identifier for the shuttle job.
    ///     Example: "6a3ba68e810d9156194530a1"
    ///   - headers: Headers of getShuttleJobByIdV2026R0 method
    /// - Returns: The `ShuttleJobV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleJobByIdV2026R0(shuttleJobId: String, headers: GetShuttleJobByIdV2026R0Headers = GetShuttleJobByIdV2026R0Headers()) async throws -> ShuttleJobV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_jobs/")\(Utils.Strings.toString(value: shuttleJobId)!)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleJobV2026R0.deserialize(from: response.data!)
    }

    /// Updates the mutable properties of an existing shuttle job identified by its
    /// ID. Only the fields supplied in the request body are changed.
    ///
    /// - Parameters:
    ///   - shuttleJobId: The unique identifier for the shuttle job.
    ///     Example: "6a3ba68e810d9156194530a1"
    ///   - requestBody: Request body of updateShuttleJobByIdV2026R0 method
    ///   - headers: Headers of updateShuttleJobByIdV2026R0 method
    /// - Returns: The `ShuttleJobV2026R0`.
    /// - Throws: The `GeneralError`.
    public func updateShuttleJobByIdV2026R0(shuttleJobId: String, requestBody: ShuttleJobUpdateRequestV2026R0, headers: UpdateShuttleJobByIdV2026R0Headers = UpdateShuttleJobByIdV2026R0Headers()) async throws -> ShuttleJobV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_jobs/")\(Utils.Strings.toString(value: shuttleJobId)!)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleJobV2026R0.deserialize(from: response.data!)
    }

    /// Permanently deletes the shuttle job identified by its ID. This does not
    /// affect content that has already been migrated.
    ///
    /// - Parameters:
    ///   - shuttleJobId: The unique identifier for the shuttle job.
    ///     Example: "6a3ba68e810d9156194530a1"
    ///   - headers: Headers of deleteShuttleJobByIdV2026R0 method
    /// - Throws: The `GeneralError`.
    public func deleteShuttleJobByIdV2026R0(shuttleJobId: String, headers: DeleteShuttleJobByIdV2026R0Headers = DeleteShuttleJobByIdV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_jobs/")\(Utils.Strings.toString(value: shuttleJobId)!)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Starts the job in the given mode. When no body is provided the job runs in
    /// simulation mode.
    ///
    /// - Parameters:
    ///   - shuttleJobId: The unique identifier for the shuttle job.
    ///     Example: "6a3ba68e810d9156194530a1"
    ///   - requestBody: Request body of createShuttleJobStartV2026R0 method
    ///   - headers: Headers of createShuttleJobStartV2026R0 method
    /// - Throws: The `GeneralError`.
    public func createShuttleJobStartV2026R0(shuttleJobId: String, requestBody: ShuttleJobStartRequestV2026R0? = nil, headers: CreateShuttleJobStartV2026R0Headers = CreateShuttleJobStartV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_jobs/")\(Utils.Strings.toString(value: shuttleJobId)!)\("/start")", method: "POST", headers: headersMap, data: requestBody != nil ? try requestBody.serialize() : nil, contentType: "application/json", responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Stops a running shuttle job identified by its ID. Any work already in
    /// progress is allowed to finish before the job transitions to a stopped
    /// state.
    ///
    /// - Parameters:
    ///   - shuttleJobId: The unique identifier for the shuttle job.
    ///     Example: "6a3ba68e810d9156194530a1"
    ///   - headers: Headers of createShuttleJobStopV2026R0 method
    /// - Throws: The `GeneralError`.
    public func createShuttleJobStopV2026R0(shuttleJobId: String, headers: CreateShuttleJobStopV2026R0Headers = CreateShuttleJobStopV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_jobs/")\(Utils.Strings.toString(value: shuttleJobId)!)\("/stop")", method: "POST", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Validates the configured account and path mappings before a transfer. Only
    /// relevant when account mapping is enabled.
    ///
    /// - Parameters:
    ///   - shuttleJobId: The unique identifier for the shuttle job.
    ///     Example: "6a3ba68e810d9156194530a1"
    ///   - headers: Headers of createShuttleJobPrepareMigrationV2026R0 method
    /// - Throws: The `GeneralError`.
    public func createShuttleJobPrepareMigrationV2026R0(shuttleJobId: String, headers: CreateShuttleJobPrepareMigrationV2026R0Headers = CreateShuttleJobPrepareMigrationV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_jobs/")\(Utils.Strings.toString(value: shuttleJobId)!)\("/prepare_migration")", method: "POST", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Returns a paginated list of runs for the shuttle job identified by
    /// `job_id`.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShuttleRunsV2026R0 method
    ///   - headers: Headers of getShuttleRunsV2026R0 method
    /// - Returns: The `ShuttleRunsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleRunsV2026R0(queryParams: GetShuttleRunsV2026R0QueryParams, headers: GetShuttleRunsV2026R0Headers = GetShuttleRunsV2026R0Headers()) async throws -> ShuttleRunsV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["job_id": Utils.Strings.toString(value: queryParams.jobId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_runs")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleRunsV2026R0.deserialize(from: response.data!)
    }

    /// Returns details for a single shuttle run identified by its ID, including
    /// its mode, state, timing, and transfer statistics.
    ///
    /// - Parameters:
    ///   - shuttleRunId: The unique identifier for the shuttle run, in the form
    ///     `{job_id}:{run_number}`.
    ///     Example: "6a3ba68e810d9156194530a1:42"
    ///   - headers: Headers of getShuttleRunByIdV2026R0 method
    /// - Returns: The `ShuttleRunV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleRunByIdV2026R0(shuttleRunId: String, headers: GetShuttleRunByIdV2026R0Headers = GetShuttleRunByIdV2026R0Headers()) async throws -> ShuttleRunV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_runs/")\(Utils.Strings.toString(value: shuttleRunId)!)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleRunV2026R0.deserialize(from: response.data!)
    }

    /// Returns a paginated list of schedules for the shuttle job identified by
    /// `job_id`.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShuttleJobSchedulesV2026R0 method
    ///   - headers: Headers of getShuttleJobSchedulesV2026R0 method
    /// - Returns: The `ShuttleJobSchedulesV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleJobSchedulesV2026R0(queryParams: GetShuttleJobSchedulesV2026R0QueryParams, headers: GetShuttleJobSchedulesV2026R0Headers = GetShuttleJobSchedulesV2026R0Headers()) async throws -> ShuttleJobSchedulesV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["job_id": Utils.Strings.toString(value: queryParams.jobId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_job_schedules")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleJobSchedulesV2026R0.deserialize(from: response.data!)
    }

    /// Creates a schedule that starts runs of the shuttle job identified by
    /// `job_id`. The schedule starts a run either at a wall-clock time or after
    /// another job's run meets a condition. Schedules cannot start a run in
    /// `scan` mode.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShuttleJobScheduleV2026R0 method
    ///   - headers: Headers of createShuttleJobScheduleV2026R0 method
    /// - Returns: The `ShuttleJobScheduleV2026R0`.
    /// - Throws: The `GeneralError`.
    public func createShuttleJobScheduleV2026R0(requestBody: ShuttleJobScheduleCreateRequestV2026R0, headers: CreateShuttleJobScheduleV2026R0Headers = CreateShuttleJobScheduleV2026R0Headers()) async throws -> ShuttleJobScheduleV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_job_schedules")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleJobScheduleV2026R0.deserialize(from: response.data!)
    }

    /// Retrieves the shuttle job schedule identified by its ID.
    ///
    /// - Parameters:
    ///   - shuttleJobScheduleId: The unique identifier for the shuttle job schedule.
    ///     Example: "7c1ba68e810d9156194530b2"
    ///   - headers: Headers of getShuttleJobScheduleByIdV2026R0 method
    /// - Returns: The `ShuttleJobScheduleV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleJobScheduleByIdV2026R0(shuttleJobScheduleId: String, headers: GetShuttleJobScheduleByIdV2026R0Headers = GetShuttleJobScheduleByIdV2026R0Headers()) async throws -> ShuttleJobScheduleV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_job_schedules/")\(Utils.Strings.toString(value: shuttleJobScheduleId)!)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleJobScheduleV2026R0.deserialize(from: response.data!)
    }

    /// Updates the mutable properties of an existing shuttle job schedule
    /// identified by its ID. Only the fields supplied in the request body are
    /// changed. The owning job cannot be changed.
    ///
    /// - Parameters:
    ///   - shuttleJobScheduleId: The unique identifier for the shuttle job schedule.
    ///     Example: "7c1ba68e810d9156194530b2"
    ///   - requestBody: Request body of updateShuttleJobScheduleByIdV2026R0 method
    ///   - headers: Headers of updateShuttleJobScheduleByIdV2026R0 method
    /// - Returns: The `ShuttleJobScheduleV2026R0`.
    /// - Throws: The `GeneralError`.
    public func updateShuttleJobScheduleByIdV2026R0(shuttleJobScheduleId: String, requestBody: ShuttleJobScheduleUpdateRequestV2026R0, headers: UpdateShuttleJobScheduleByIdV2026R0Headers = UpdateShuttleJobScheduleByIdV2026R0Headers()) async throws -> ShuttleJobScheduleV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_job_schedules/")\(Utils.Strings.toString(value: shuttleJobScheduleId)!)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleJobScheduleV2026R0.deserialize(from: response.data!)
    }

    /// Permanently deletes the shuttle job schedule identified by its ID. This
    /// does not affect runs that have already started.
    ///
    /// - Parameters:
    ///   - shuttleJobScheduleId: The unique identifier for the shuttle job schedule.
    ///     Example: "7c1ba68e810d9156194530b2"
    ///   - headers: Headers of deleteShuttleJobScheduleByIdV2026R0 method
    /// - Throws: The `GeneralError`.
    public func deleteShuttleJobScheduleByIdV2026R0(shuttleJobScheduleId: String, headers: DeleteShuttleJobScheduleByIdV2026R0Headers = DeleteShuttleJobScheduleByIdV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_job_schedules/")\(Utils.Strings.toString(value: shuttleJobScheduleId)!)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Returns a paginated list of path mappings for the shuttle job identified
    /// by `job_id`.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShuttlePathMappingsV2026R0 method
    ///   - headers: Headers of getShuttlePathMappingsV2026R0 method
    /// - Returns: The `ShuttlePathMappingsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttlePathMappingsV2026R0(queryParams: GetShuttlePathMappingsV2026R0QueryParams, headers: GetShuttlePathMappingsV2026R0Headers = GetShuttlePathMappingsV2026R0Headers()) async throws -> ShuttlePathMappingsV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["job_id": Utils.Strings.toString(value: queryParams.jobId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_path_mappings")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttlePathMappingsV2026R0.deserialize(from: response.data!)
    }

    /// Creates a path mapping that connects a source location on the migrated
    /// system to a destination in Box for the given shuttle job.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShuttlePathMappingV2026R0 method
    ///   - headers: Headers of createShuttlePathMappingV2026R0 method
    /// - Returns: The `ShuttlePathMappingV2026R0`.
    /// - Throws: The `GeneralError`.
    public func createShuttlePathMappingV2026R0(requestBody: ShuttlePathMappingCreateRequestV2026R0, headers: CreateShuttlePathMappingV2026R0Headers = CreateShuttlePathMappingV2026R0Headers()) async throws -> ShuttlePathMappingV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_path_mappings")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttlePathMappingV2026R0.deserialize(from: response.data!)
    }

    /// Returns details for a single shuttle path mapping identified by its ID,
    /// including the source location and destination, if any.
    ///
    /// - Parameters:
    ///   - shuttlePathMappingId: The unique identifier for the shuttle path mapping.
    ///     Example: "6a3ba7a24ea17bc9461eeacd"
    ///   - headers: Headers of getShuttlePathMappingByIdV2026R0 method
    /// - Returns: The `ShuttlePathMappingV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttlePathMappingByIdV2026R0(shuttlePathMappingId: String, headers: GetShuttlePathMappingByIdV2026R0Headers = GetShuttlePathMappingByIdV2026R0Headers()) async throws -> ShuttlePathMappingV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_path_mappings/")\(Utils.Strings.toString(value: shuttlePathMappingId)!)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttlePathMappingV2026R0.deserialize(from: response.data!)
    }

    /// Updates the mutable properties of an existing shuttle path mapping
    /// identified by its ID. Only the fields supplied in the request body are
    /// changed.
    ///
    /// - Parameters:
    ///   - shuttlePathMappingId: The unique identifier for the shuttle path mapping.
    ///     Example: "6a3ba7a24ea17bc9461eeacd"
    ///   - requestBody: Request body of updateShuttlePathMappingByIdV2026R0 method
    ///   - headers: Headers of updateShuttlePathMappingByIdV2026R0 method
    /// - Returns: The `ShuttlePathMappingV2026R0`.
    /// - Throws: The `GeneralError`.
    public func updateShuttlePathMappingByIdV2026R0(shuttlePathMappingId: String, requestBody: ShuttlePathMappingUpdateRequestV2026R0, headers: UpdateShuttlePathMappingByIdV2026R0Headers = UpdateShuttlePathMappingByIdV2026R0Headers()) async throws -> ShuttlePathMappingV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_path_mappings/")\(Utils.Strings.toString(value: shuttlePathMappingId)!)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttlePathMappingV2026R0.deserialize(from: response.data!)
    }

    /// Permanently deletes the shuttle path mapping identified by its ID. This
    /// does not affect content that has already been migrated.
    ///
    /// - Parameters:
    ///   - shuttlePathMappingId: The unique identifier for the shuttle path mapping.
    ///     Example: "6a3ba7a24ea17bc9461eeacd"
    ///   - headers: Headers of deleteShuttlePathMappingByIdV2026R0 method
    /// - Throws: The `GeneralError`.
    public func deleteShuttlePathMappingByIdV2026R0(shuttlePathMappingId: String, headers: DeleteShuttlePathMappingByIdV2026R0Headers = DeleteShuttlePathMappingByIdV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_path_mappings/")\(Utils.Strings.toString(value: shuttlePathMappingId)!)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Accepts a spreadsheet of path mappings, already stored in Box, and replaces
    /// the job's path mappings.
    /// A file that is not a mapping workbook, or that exceeds the size or row
    /// limits (10 MiB Box download limit; 100,000 mapping rows), returns `400`
    /// synchronously and leaves the job unchanged.
    /// An accepted import always replaces every path mapping on the job. When all
    /// rows are valid the workbook is deployed in full. When any row is invalid
    /// the job ends with no path mappings and `mapping_state` becomes
    /// `paths_import_rejected` until the next import or the next manual
    /// path-mapping change. Row problems are listed by
    /// `GET /shuttle_mapping_errors?job_id=…` with category `path_import`, messages
    /// of the form `Row N: …`, at most 500 entries plus one overflow entry.
    /// Validation and deployment are asynchronous after acceptance. Poll
    /// `GET /shuttle_jobs/{shuttle_job_id}` while `mapping_state` is
    /// `importing_paths`. Only one import may be in flight per job.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShuttlePathMappingImportV2026R0 method
    ///   - headers: Headers of createShuttlePathMappingImportV2026R0 method
    /// - Throws: The `GeneralError`.
    public func createShuttlePathMappingImportV2026R0(requestBody: ShuttlePathMappingImportCreateRequestV2026R0, headers: CreateShuttlePathMappingImportV2026R0Headers = CreateShuttlePathMappingImportV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_path_mapping_imports")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Accepts a spreadsheet of subject (user and group) mappings, already stored
    /// in Box, and replaces the job's subject mappings.
    /// A file that is not a subject-mapping workbook, or that exceeds the size or
    /// row limits (10 MiB Box download limit; 50,000 mapping rows), returns `400`
    /// synchronously and leaves the job unchanged.
    /// An accepted import always replaces every subject mapping on the job. When
    /// all rows are valid the workbook is deployed in full. When any row is
    /// invalid the job ends with no subject mappings and `mapping_state` becomes
    /// `subjects_import_rejected` until the next import or the next manual
    /// subject-mapping change. Row problems are listed by
    /// `GET /shuttle_mapping_errors?job_id=…` with category `subject_import`,
    /// messages of the form `Row N: …`, at most 500 entries plus one overflow
    /// entry.
    /// Validation and deployment are asynchronous after acceptance. Poll
    /// `GET /shuttle_jobs/{shuttle_job_id}` while `mapping_state` is
    /// `importing_subjects`. Only one import may be in flight per job. The job
    /// must map subjects (`account_mapping` enabled) and its source scan must be
    /// finished; otherwise the request returns `409`.
    /// 
    /// Expected workbook format (API clients cannot download the UI template):
    /// sheets `Users` and/or `Groups` (a sheet named `Subjects` is also accepted).
    /// Columns are `Source User <Key>`, `Target User <Key>`, `Skip` on `Users`,
    /// and `Source Group <Key>`, `Target Group <Key>`, `Skip` on `Groups`, where
    /// `<Key>` is the primary identifier for that role and system:
    /// - Users: `Email` for most systems; `ID` for `SharePoint` (2007/2010/2013);
    ///   `Name` for Windows (`windows_union`, stored as the user id).
    /// - Groups: `Name` for most systems; `Email` for Google Drive admin groups.
    /// Source rows for a template can be taken from
    /// `GET /shuttle_discovered_subjects`.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShuttleSubjectMappingImportV2026R0 method
    ///   - headers: Headers of createShuttleSubjectMappingImportV2026R0 method
    /// - Throws: The `GeneralError`.
    public func createShuttleSubjectMappingImportV2026R0(requestBody: ShuttleSubjectMappingImportCreateRequestV2026R0, headers: CreateShuttleSubjectMappingImportV2026R0Headers = CreateShuttleSubjectMappingImportV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_subject_mapping_imports")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Returns a paginated list of subject mappings for the shuttle job identified
    /// by `job_id`.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShuttleSubjectMappingsV2026R0 method
    ///   - headers: Headers of getShuttleSubjectMappingsV2026R0 method
    /// - Returns: The `ShuttleSubjectMappingsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleSubjectMappingsV2026R0(queryParams: GetShuttleSubjectMappingsV2026R0QueryParams, headers: GetShuttleSubjectMappingsV2026R0Headers = GetShuttleSubjectMappingsV2026R0Headers()) async throws -> ShuttleSubjectMappingsV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["job_id": Utils.Strings.toString(value: queryParams.jobId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_subject_mappings")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleSubjectMappingsV2026R0.deserialize(from: response.data!)
    }

    /// Creates a subject mapping that connects a discovered source subject to a
    /// Box user or group for the given shuttle job.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShuttleSubjectMappingV2026R0 method
    ///   - headers: Headers of createShuttleSubjectMappingV2026R0 method
    /// - Returns: The `ShuttleSubjectMappingV2026R0`.
    /// - Throws: The `GeneralError`.
    public func createShuttleSubjectMappingV2026R0(requestBody: ShuttleSubjectMappingCreateRequestV2026R0, headers: CreateShuttleSubjectMappingV2026R0Headers = CreateShuttleSubjectMappingV2026R0Headers()) async throws -> ShuttleSubjectMappingV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_subject_mappings")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleSubjectMappingV2026R0.deserialize(from: response.data!)
    }

    /// Returns details for a single shuttle subject mapping identified by its ID,
    /// including the source subject and Box target, if any.
    ///
    /// - Parameters:
    ///   - shuttleSubjectMappingId: The unique identifier for the shuttle subject mapping.
    ///     Example: "6a3ba7b12ea17bc9461eeace"
    ///   - headers: Headers of getShuttleSubjectMappingByIdV2026R0 method
    /// - Returns: The `ShuttleSubjectMappingV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleSubjectMappingByIdV2026R0(shuttleSubjectMappingId: String, headers: GetShuttleSubjectMappingByIdV2026R0Headers = GetShuttleSubjectMappingByIdV2026R0Headers()) async throws -> ShuttleSubjectMappingV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_subject_mappings/")\(Utils.Strings.toString(value: shuttleSubjectMappingId)!)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleSubjectMappingV2026R0.deserialize(from: response.data!)
    }

    /// Updates the mutable properties of an existing shuttle subject mapping
    /// identified by its ID. Only the fields supplied in the request body are
    /// changed.
    ///
    /// - Parameters:
    ///   - shuttleSubjectMappingId: The unique identifier for the shuttle subject mapping.
    ///     Example: "6a3ba7b12ea17bc9461eeace"
    ///   - requestBody: Request body of updateShuttleSubjectMappingByIdV2026R0 method
    ///   - headers: Headers of updateShuttleSubjectMappingByIdV2026R0 method
    /// - Returns: The `ShuttleSubjectMappingV2026R0`.
    /// - Throws: The `GeneralError`.
    public func updateShuttleSubjectMappingByIdV2026R0(shuttleSubjectMappingId: String, requestBody: ShuttleSubjectMappingUpdateRequestV2026R0, headers: UpdateShuttleSubjectMappingByIdV2026R0Headers = UpdateShuttleSubjectMappingByIdV2026R0Headers()) async throws -> ShuttleSubjectMappingV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_subject_mappings/")\(Utils.Strings.toString(value: shuttleSubjectMappingId)!)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleSubjectMappingV2026R0.deserialize(from: response.data!)
    }

    /// Permanently deletes the shuttle subject mapping identified by its ID.
    ///
    /// - Parameters:
    ///   - shuttleSubjectMappingId: The unique identifier for the shuttle subject mapping.
    ///     Example: "6a3ba7b12ea17bc9461eeace"
    ///   - headers: Headers of deleteShuttleSubjectMappingByIdV2026R0 method
    /// - Throws: The `GeneralError`.
    public func deleteShuttleSubjectMappingByIdV2026R0(shuttleSubjectMappingId: String, headers: DeleteShuttleSubjectMappingByIdV2026R0Headers = DeleteShuttleSubjectMappingByIdV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_subject_mappings/")\(Utils.Strings.toString(value: shuttleSubjectMappingId)!)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Returns a paginated list of subjects discovered on the source system for
    /// the shuttle job identified by `job_id`.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShuttleDiscoveredSubjectsV2026R0 method
    ///   - headers: Headers of getShuttleDiscoveredSubjectsV2026R0 method
    /// - Returns: The `ShuttleDiscoveredSubjectsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleDiscoveredSubjectsV2026R0(queryParams: GetShuttleDiscoveredSubjectsV2026R0QueryParams, headers: GetShuttleDiscoveredSubjectsV2026R0Headers = GetShuttleDiscoveredSubjectsV2026R0Headers()) async throws -> ShuttleDiscoveredSubjectsV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["job_id": Utils.Strings.toString(value: queryParams.jobId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_discovered_subjects")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleDiscoveredSubjectsV2026R0.deserialize(from: response.data!)
    }

    /// Returns a paginated list of source or target path entries for a shuttle
    /// job. Call with only `job_id` and `side` to list the roots, then browse one
    /// level at a time using `path`, `path_id`, or both. Each entry includes
    /// `path`, `path_id`, `is_directory`, and a `scope` object (`account` or
    /// `shared_space`) so a mapping can be created from that row without extra
    /// browse state. Valid values depend on the selected system.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShuttlePathEntriesV2026R0 method
    ///   - headers: Headers of getShuttlePathEntriesV2026R0 method
    /// - Returns: The `ShuttlePathEntriesV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttlePathEntriesV2026R0(queryParams: GetShuttlePathEntriesV2026R0QueryParams, headers: GetShuttlePathEntriesV2026R0Headers = GetShuttlePathEntriesV2026R0Headers()) async throws -> ShuttlePathEntriesV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["job_id": Utils.Strings.toString(value: queryParams.jobId), "side": Utils.Strings.toString(value: queryParams.side), "path": Utils.Strings.toString(value: queryParams.path), "path_id": Utils.Strings.toString(value: queryParams.pathId), "account_email": Utils.Strings.toString(value: queryParams.accountEmail), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_path_entries")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttlePathEntriesV2026R0.deserialize(from: response.data!)
    }

    /// Returns a paginated list of mapping errors for a shuttle job. Only the latest
    /// record for each error is returned. The revision field identifies the mapping
    /// revision in which that error was generated.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShuttleMappingErrorsV2026R0 method
    ///   - headers: Headers of getShuttleMappingErrorsV2026R0 method
    /// - Returns: The `ShuttleMappingErrorsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleMappingErrorsV2026R0(queryParams: GetShuttleMappingErrorsV2026R0QueryParams, headers: GetShuttleMappingErrorsV2026R0Headers = GetShuttleMappingErrorsV2026R0Headers()) async throws -> ShuttleMappingErrorsV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["job_id": Utils.Strings.toString(value: queryParams.jobId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_mapping_errors")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleMappingErrorsV2026R0.deserialize(from: response.data!)
    }

    /// Returns a paginated list of reports generated for the shuttle run
    /// identified by `run_id`.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getShuttleReportsV2026R0 method
    ///   - headers: Headers of getShuttleReportsV2026R0 method
    /// - Returns: The `ShuttleReportsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleReportsV2026R0(queryParams: GetShuttleReportsV2026R0QueryParams, headers: GetShuttleReportsV2026R0Headers = GetShuttleReportsV2026R0Headers()) async throws -> ShuttleReportsV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["run_id": Utils.Strings.toString(value: queryParams.runId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_reports")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleReportsV2026R0.deserialize(from: response.data!)
    }

    /// Requests asynchronous generation of a report for a shuttle run. The
    /// report is returned immediately in `pending` or `processing` status.
    /// Poll `GET /shuttle_reports/{shuttle_report_id}` while `status` is
    /// `pending` or `processing`. Stop when `status` is `complete`, `failed`,
    /// `canceled`, or `unknown`. Repeating this request with the same
    /// parameters reuses the existing report instead of creating a duplicate.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createShuttleReportV2026R0 method
    ///   - headers: Headers of createShuttleReportV2026R0 method
    /// - Returns: The `ShuttleReportV2026R0`.
    /// - Throws: The `GeneralError`.
    public func createShuttleReportV2026R0(requestBody: ShuttleReportCreateRequestV2026R0, headers: CreateShuttleReportV2026R0Headers = CreateShuttleReportV2026R0Headers()) async throws -> ShuttleReportV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_reports")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleReportV2026R0.deserialize(from: response.data!)
    }

    /// Returns details for a single shuttle report identified by its ID,
    /// including generation status and, once generation finishes, the Box
    /// output reference.
    ///
    /// - Parameters:
    ///   - shuttleReportId: The unique identifier for the shuttle report.
    ///     Example: "6a3ba8d14f2c91e8370b4d12"
    ///   - headers: Headers of getShuttleReportByIdV2026R0 method
    /// - Returns: The `ShuttleReportV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getShuttleReportByIdV2026R0(shuttleReportId: String, headers: GetShuttleReportByIdV2026R0Headers = GetShuttleReportByIdV2026R0Headers()) async throws -> ShuttleReportV2026R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/shuttle_reports/")\(Utils.Strings.toString(value: shuttleReportId)!)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ShuttleReportV2026R0.deserialize(from: response.data!)
    }

}
