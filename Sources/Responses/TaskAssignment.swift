//
//  TaskAssignment.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer on 6/18/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Status of assignment.
public enum AssignmentStatus: BoxEnum {
    /// Completed
    case completed
    /// Incomplete
    case incomplete
    /// Approved
    case approved
    /// Rejected
    case rejected
    /// Custom value not implemented in this version of SDK.
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "completed":
            self = .completed
        case "incomplete":
            self = .incomplete
        case "approved":
            self = .approved
        case "rejected":
            self = .rejected
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .completed:
            return "completed"
        case .incomplete:
            return "incomplete"
        case .approved:
            return "approved"
        case .rejected:
            return "rejected"
        case let .customValue(value):
            return value
        }
    }
}

/// State of assignment.
public enum AssignmentState: BoxEnum {
    /// Completed
    case completed
    /// Incomplete
    case incomplete
    /// Approved
    case approved
    /// Rejected
    case rejected
    /// Custom value not implemented in this version of SDK.
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "completed":
            self = .completed
        case "incomplete":
            self = .incomplete
        case "approved":
            self = .approved
        case "rejected":
            self = .rejected
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .completed:
            return "completed"
        case .incomplete:
            return "incomplete"
        case .approved:
            return "approved"
        case .rejected:
            return "rejected"
        case let .customValue(value):
            return value
        }
    }
}

/// Task assignment to a single user. There can be multiple assignments on a given task.
public class TaskAssignment: BoxModel {
    // MARK: - BoxModel

    private static var resourceType: String = "task_assignment"
    /// Box item type.
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// File an assignment is on.
    public let item: TaskItem?
    /// Date of assignment.
    public let assignedAt: Date?
    /// Assignment status.
    public let status: AssignmentStatus?
    /// A message from the assignee about this task.
    public let message: String?
    /// The user task is assigned to.
    public let assignedTo: User?
    /// The user task is assigned by.
    public let assignedBy: User?
    /// State of assignment. Can be completed, incomplete, approved, or rejected.
    public let resolutionState: AssignmentState?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == TaskAssignment.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [TaskAssignment.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        item = try BoxJSONDecoder.optionalDecode(json: json, forKey: "item")
        assignedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "assigned_at")
        status = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status")
        message = try BoxJSONDecoder.optionalDecode(json: json, forKey: "message")
        assignedTo = try BoxJSONDecoder.optionalDecode(json: json, forKey: "assigned_to")
        assignedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "assigned_by")
        resolutionState = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "resolution_state")
    }
}
