//
//  TasksModule.swift
//  BoxSDK-iOS
//
//  Created by Daniel Cech on 8/27/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Provides Tasks management
public class TasksModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    // MARK: - Tasks

    /// Fetches a specific task.
    ///
    /// - Parameters:
    ///   - taskId: The ID of the task.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full task object or an error.
    public func get(
        taskId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Task>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/tasks/\(taskId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Used to create a single task for single user on a single file.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file this task is associated with.
    ///   - action: The action the task assignee will be prompted to do.
    ///         Must be review for an approval task and complete for a general task
    ///   - message: An optional message to include with the task.
    ///   - dueAt: When this task is due.
    ///   - completionRule: The rule that determines whether a task is completed (default value set by API if not passed is all_assignees)
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full task object or an error.
    public func create(
        fileId: String,
        action: TaskAction,
        message: String? = nil,
        dueAt: Date? = nil,
        completionRule: TaskCompletionRule? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<Task>
    ) {
        var json = [String: Any]()
        json["item"] = ["type": "file", "id": fileId]
        json["action"] = action.description
        json["message"] = message
        json["due_at"] = dueAt?.iso8601
        json["completion_rule"] = completionRule?.description

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/tasks", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Updates a specific task.
    ///
    /// - Parameters:
    ///   - taskId: The ID of the updated task.
    ///   - action: The action the task assignee will be prompted to do.
    ///         Must be review for an approval task and complete for a general task
    ///   - message: An optional message to include with the task.
    ///   - dueAt: When this task is due.
    ///   - completionRule: The rule that determines whether a task is completed (default value set by API if not passed is all_assignees)
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full task object or an error.
    public func update(
        taskId: String,
        action: TaskAction,
        message: String? = nil,
        dueAt: Date? = nil,
        completionRule: TaskCompletionRule? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<Task>
    ) {
        var json = [String: Any]()
        json["action"] = action.description
        json["message"] = message
        json["due_at"] = dueAt?.iso8601
        json["completion_rule"] = completionRule?.description

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/tasks/\(taskId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Permanently deletes a specific task.
    ///
    /// - Parameters:
    ///   - taskId: The ID of the deleted task.
    ///   - completion: Returns a full task object or an error.
    public func delete(
        taskId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/tasks/\(taskId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    // MARK: - Task Assignments

    /// Fetches a specific task assignment.
    ///
    /// - Parameters:
    ///   - taskAssignmentId: The ID of the task assignment.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full task assignment object or an error.
    public func getAssignment(
        taskAssignmentId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<TaskAssignment>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/task_assignments/\(taskAssignmentId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Used to assign a task to a single user identified by userId.
    /// There can be multiple assignments on a given task.
    ///
    /// - Parameters:
    ///   - taskId: The ID of the task this assignment is for.
    ///   - userId: The ID of the user this assignment is for.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full task assignment object or an error.
    public func assign(
        taskId: String,
        userId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<TaskAssignment>
    ) {
        var json = [String: Any]()
        json["task"] = ["type": "task", "id": taskId]
        json["assign_to"] = ["id": userId]

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/task_assignments", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Used to assign a task to a single user identified by login.
    /// There can be multiple assignments on a given task.
    ///
    /// - Parameters:
    ///   - taskId: The ID of the task this assignment is for.
    ///   - login: Optional. The login email address for the user this assignment is for.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full task assignment object or an error.
    public func assignByEmail(
        taskId: String,
        email: String,
        fields: [String]? = nil,
        completion: @escaping Callback<TaskAssignment>
    ) {
        var json = [String: Any]()
        json["task"] = ["type": "task", "id": taskId]
        json["assign_to"] = ["login": email]

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/task_assignments", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Used to update a task assignment.
    ///
    /// - Parameters:
    ///   - taskAssignmentId: The ID of the task assignment.
    ///   - message: An optional message to include with the task.
    ///   - resolutionState: Optional. The resolution state of task.
    ///       When updating a task assignment, the resolution state depends on the action
    ///       type of the task. If you want to update a review task, the resolution_state
    ///       can be set to incomplete, approved, or rejected. A complete task
    ///       can have a resolutionState of incomplete or completed.
    ///   - completion: Returns a full task assignment object or an error.
    public func updateAssignment(
        taskAssignmentId: String,
        message: String? = nil,
        resolutionState: AssignmentState? = nil,
        completion: @escaping Callback<TaskAssignment>
    ) {
        var json = [String: Any]()
        json["message"] = message
        json["resolution_state"] = resolutionState?.description

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/task_assignments/\(taskAssignmentId)", configuration: boxClient.configuration),
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Permanently deletes a specific task.
    ///
    /// - Parameters:
    ///   - taskId: The ID of the deleted task.
    ///   - completion: Returns a success or an error if task assignment can't be deleted.
    public func deleteAssignment(
        taskAssignmentId: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/task_assignments/\(taskAssignmentId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Fetches a all task assignments for particular task.
    ///
    /// - Parameters:
    ///   - taskAssignmentId: The ID of the task assignment.
    ///   - completion: Returns a list of task assignments for some task or an error.
    public func listAssignments(
        forTaskId taskId: String,
        completion: @escaping Callback<[TaskAssignment]>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/tasks/\(taskId)/assignments", configuration: boxClient.configuration),
            completion: { result in
                let objectResult: Result<EntryContainer<TaskAssignment>, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }
                let mappedResult: Result<[TaskAssignment], BoxSDKError> = objectResult.map { $0.entries }
                completion(mappedResult)
            }
        )
    }
}
