//
//  Task.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/22/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

public enum TaskCompletionRule: BoxEnum {
    case allAssignees
    case anyAssignee
    case customValue(String)

    /// Creates a new value
    ///
    /// - Parameters:
    ///    value: String representation of a task completion rule rawValue
    public init(_ value: String) {
        switch value {
        case "all_assignees":
            self = .allAssignees
        case "any_assignee":
            self = .anyAssignee
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of type that can be used in a request.
    public var description: String {
        switch self {
        case .allAssignees:
            return "all_assignees"
        case .anyAssignee:
            return "any_assignee"
        case let .customValue(userValue):
            return userValue
        }
    }
}

public enum TaskAction: BoxEnum {
    case review
    case complete
    case customValue(String)

    /// Creates a new value
    ///
    /// - Parameters:
    ///    value: String representation of an TaskAction rawValue
    public init(_ value: String) {
        switch value {
        case "review":
            self = .review
        case "complete":
            self = .complete
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of type that can be used in a request.
    public var description: String {
        switch self {
        case .review:
            return "review"
        case .complete:
            return "complete"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Enables file-centric workflows in Box. User can create tasks on files and assign them to collaborators on Box.
/// You can read more about tasks in Box [here](https://community.box.com/t5/Sharing-Content-with-Box/Adding-Comments-and-Tasks/ta-p/19815).
public class Task: BoxModel {
    // MARK: - BoxModel

    private static var resourceType: String = "task"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// The file associated with the task.
    public let item: TaskItem?
    /// When the task is due.
    public let dueAt: Date?
    /// The action the task assignee will be prompted to do. Depending on task type, this can be "review" or "complete".
    public let action: TaskAction?
    /// A message that will be included with the task.
    public let message: String?
    /// A collection of mini task_assignment objects associated with the task.
    public let taskAssignmentCollection: EntryContainer<TaskAssignment>?
    /// Whether the task has been completed.
    public let isCompleted: Bool?
    /// The user who created the task.
    public let createdBy: User?
    /// When the task object was created.
    public let createdAt: Date?
    /// The rule that determines whether a task is completed
    public let completionRule: TaskCompletionRule?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == Task.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [Task.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        item = try BoxJSONDecoder.optionalDecode(json: json, forKey: "item")
        dueAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "due_at")
        action = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "action")
        message = try BoxJSONDecoder.optionalDecode(json: json, forKey: "message")
        taskAssignmentCollection = try BoxJSONDecoder.optionalDecode(json: json, forKey: "task_assignment_collection")
        isCompleted = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_completed")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        completionRule = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "completion_rule")
    }
}
