import Foundation

public class TaskAssignmentsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Lists all of the assignments for a given task.
    ///
    /// - Parameters:
    ///   - taskId: The ID of the task.
    ///     Example: "12345"
    ///   - headers: Headers of getTaskAssignments method
    /// - Returns: The `TaskAssignments`.
    /// - Throws: The `GeneralError`.
    public func getTaskAssignments(taskId: String, headers: GetTaskAssignmentsHeaders = GetTaskAssignmentsHeaders()) async throws -> TaskAssignments {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/tasks/")\(taskId)\("/assignments")", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TaskAssignments.deserialize(from: response.data!)
    }

    /// Assigns a task to a user.
    /// 
    /// A task can be assigned to more than one user by creating multiple
    /// assignments.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createTaskAssignment method
    ///   - headers: Headers of createTaskAssignment method
    /// - Returns: The `TaskAssignment`.
    /// - Throws: The `GeneralError`.
    public func createTaskAssignment(requestBody: CreateTaskAssignmentRequestBody, headers: CreateTaskAssignmentHeaders = CreateTaskAssignmentHeaders()) async throws -> TaskAssignment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/task_assignments")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TaskAssignment.deserialize(from: response.data!)
    }

    /// Retrieves information about a task assignment.
    ///
    /// - Parameters:
    ///   - taskAssignmentId: The ID of the task assignment.
    ///     Example: "12345"
    ///   - headers: Headers of getTaskAssignmentById method
    /// - Returns: The `TaskAssignment`.
    /// - Throws: The `GeneralError`.
    public func getTaskAssignmentById(taskAssignmentId: String, headers: GetTaskAssignmentByIdHeaders = GetTaskAssignmentByIdHeaders()) async throws -> TaskAssignment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/task_assignments/")\(taskAssignmentId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TaskAssignment.deserialize(from: response.data!)
    }

    /// Updates a task assignment. This endpoint can be
    /// used to update the state of a task assigned to a user.
    ///
    /// - Parameters:
    ///   - taskAssignmentId: The ID of the task assignment.
    ///     Example: "12345"
    ///   - requestBody: Request body of updateTaskAssignmentById method
    ///   - headers: Headers of updateTaskAssignmentById method
    /// - Returns: The `TaskAssignment`.
    /// - Throws: The `GeneralError`.
    public func updateTaskAssignmentById(taskAssignmentId: String, requestBody: UpdateTaskAssignmentByIdRequestBody = UpdateTaskAssignmentByIdRequestBody(), headers: UpdateTaskAssignmentByIdHeaders = UpdateTaskAssignmentByIdHeaders()) async throws -> TaskAssignment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/task_assignments/")\(taskAssignmentId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TaskAssignment.deserialize(from: response.data!)
    }

    /// Deletes a specific task assignment.
    ///
    /// - Parameters:
    ///   - taskAssignmentId: The ID of the task assignment.
    ///     Example: "12345"
    ///   - headers: Headers of deleteTaskAssignmentById method
    /// - Throws: The `GeneralError`.
    public func deleteTaskAssignmentById(taskAssignmentId: String, headers: DeleteTaskAssignmentByIdHeaders = DeleteTaskAssignmentByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/task_assignments/")\(taskAssignmentId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
