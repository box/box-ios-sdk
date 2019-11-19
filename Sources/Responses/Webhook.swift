//
//  Webhook.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 8/29/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

public class Webhook: BoxModel {
    //    swiftlint:disable cyclomatic_complexity
    /// Event triggers for webhooks
    public enum EventTriggers: BoxEnum {
        /// A file is uploaded
        case fileUploaded
        /// A file is previewed
        case filePreviewed
        /// A file is downloaded
        case fileDownloaded
        /// A file is moved to the trash
        case fileTrashed
        /// A file is permanently deleted
        case fileDeleted
        /// A file is restored from the trash
        case fileRestored
        /// A file is copied
        case fileCopied
        /// A file is moved from one folder to another
        case fileMoved
        /// A file is locked
        case fileLocked
        /// A file is unlocked
        case fileUnlocked
        /// A file was renamed
        case fileRenamed
        /// A comment object is created
        case commentCreated
        /// A comment object is edited
        case commentUpdated
        /// A comment object is removed
        case commentDeleted
        /// A task is created
        case taskAssignmentCreated
        /// A task assignment is changed
        case taskAssignmentUpdated
        /// A new metadata template instance is associated with a file or folder
        case metadataInstanceCreated
        /// An attribute (value) is updated/deleted for an existing metadata template instance associated with a file or folder
        case metadataInstanceUpdated
        /// An existing metadata template instance associated with a file or folder is deleted
        case metadataInstanceDeleted
        /// A folder is created
        case folderCreated
        /// A folder was renamed
        case folderRenamed
        /// A folder is downloaded
        case folderDownloaded
        /// A folder is restored from the trash
        case folderRestored
        /// A folder is permanently removed
        case folderDeleted
        /// A copy of a folder is made
        case folderCopied
        /// A folder is moved to a different folder
        case folderMoved
        /// A folder is moved to the trash
        case folderTrashed
        /// When a webhook is deleted
        case webhookDeleted
        /// A collaboration is created
        case collaborationCreated
        /// A collaboration has been accepted
        case collaborationAccepted
        /// A collaboration has been rejected
        case collaborationRejected
        /// A collaboration has been removed
        case collaborationRemoved
        /// A collaboration has been updated
        case collaborationUpdated
        /// A shared link was deleted
        case sharedLinkDeleted
        /// A shared link was created
        case sharedLinkCreated
        /// A shared link was updated
        case sharedLinkUpdated
        /// Custom value for enum values not yet implemented in the SDK
        case customValue(String)

        public init(_ value: String) {
            switch value {
            case "FILE.UPLOADED":
                self = .fileUploaded
            case "FILE.PREVIEWED":
                self = .filePreviewed
            case "FILE.DOWNLOADED":
                self = .fileDownloaded
            case "FILE.TRASHED":
                self = .fileTrashed
            case "FILE.DELETED":
                self = .fileDeleted
            case "FILE.RESTORED":
                self = .fileRestored
            case "FILE.COPIED":
                self = .fileCopied
            case "FILE.MOVED":
                self = .fileMoved
            case "FILE.LOCKED":
                self = .fileLocked
            case "FILE.UNLOCKED":
                self = .fileUnlocked
            case "FILE.RENAMED":
                self = .fileRenamed
            case "COMMENT.CREATED":
                self = .commentCreated
            case "COMMENT.UPDATED":
                self = .commentUpdated
            case "COMMENT.DELETED":
                self = .commentDeleted
            case "TASK_ASSIGNMENT.CREATED":
                self = .taskAssignmentCreated
            case "TASK_ASSIGNMENT.UPDATED":
                self = .taskAssignmentUpdated
            case "METADATA_INSTANCE.CREATED":
                self = .metadataInstanceCreated
            case "METADATA_INSTANCE.UPDATED":
                self = .metadataInstanceUpdated
            case "METADATA_INSTANCE.DELETED":
                self = .metadataInstanceDeleted
            case "FOLDER.CREATED":
                self = .folderCreated
            case "FOLDER.RENAMED":
                self = .folderRenamed
            case "FOLDER.DOWNLOADED":
                self = .folderDownloaded
            case "FOLDER.RESTORED":
                self = .folderRestored
            case "FOLDER.DELETED":
                self = .folderDeleted
            case "FOLDER.COPIED":
                self = .folderCopied
            case "FOLDER.MOVED":
                self = .folderMoved
            case "FOLDER.TRASHED":
                self = .folderTrashed
            case "WEBHOOK.DELETED":
                self = .webhookDeleted
            case "COLLABORATION.CREATED":
                self = .collaborationCreated
            case "COLLABORATION.ACCEPTED":
                self = .collaborationAccepted
            case "COLLABORATION.REJECTED":
                self = .collaborationRejected
            case "COLLABORATION.REMOVED":
                self = .collaborationRemoved
            case "COLLABORATION.UPDATED":
                self = .collaborationUpdated
            case "SHARED_LINK.DELETED":
                self = .sharedLinkDeleted
            case "SHARED_LINK.CREATED":
                self = .sharedLinkCreated
            case "SHARED_LINK.UPDATED":
                self = .sharedLinkUpdated
            default:
                self = .customValue(value)
            }
        }

        public var description: String {
            switch self {
            case .fileUploaded:
                return "FILE.UPLOADED"
            case .filePreviewed:
                return "FILE.PREVIEWED"
            case .fileDownloaded:
                return "FILE.DOWNLOADED"
            case .fileTrashed:
                return "FILE.TRASHED"
            case .fileDeleted:
                return "FILE.DELETED"
            case .fileRestored:
                return "FILE.RESTORED"
            case .fileCopied:
                return "FILE.COPIED"
            case .fileMoved:
                return "FILE.MOVED"
            case .fileLocked:
                return "FILE.LOCKED"
            case .fileUnlocked:
                return "FILE.UNLOCKED"
            case .fileRenamed:
                return "FILE.RENAMED"
            case .commentCreated:
                return "COMMENT.CREATED"
            case .commentUpdated:
                return "COMMENT.UPDATED"
            case .commentDeleted:
                return "COMMENT.DELETED"
            case .taskAssignmentCreated:
                return "TASK_ASSIGNMENT.CREATED"
            case .taskAssignmentUpdated:
                return "TASK_ASSIGNMENT.UPDATED"
            case .metadataInstanceCreated:
                return "METEDATA_INSTANCE.CREATED"
            case .metadataInstanceUpdated:
                return "METEDATA_INSTANCE.UPDATED"
            case .metadataInstanceDeleted:
                return "METADATA_INSTANCE.DELETED"
            case .folderCreated:
                return "FOLDER.CREATED"
            case .folderRenamed:
                return "FOLDER.RENAMED"
            case .folderDownloaded:
                return "FOLDER.DOWNLOADED"
            case .folderRestored:
                return "FOLDER.RESTORED"
            case .folderDeleted:
                return "FOLDER.DELETED"
            case .folderCopied:
                return "FOLDER.COPIED"
            case .folderMoved:
                return "FOLDER.MOVED"
            case .folderTrashed:
                return "FOLDER.TRASHED"
            case .webhookDeleted:
                return "WEBHOOK.DELETED"
            case .collaborationCreated:
                return "COLLABORATION.CREATED"
            case .collaborationAccepted:
                return "COLLABORATION.ACCEPTED"
            case .collaborationRejected:
                return "COLLABORATION.REJECTED"
            case .collaborationRemoved:
                return "COLLABORATION.REMOVED"
            case .collaborationUpdated:
                return "COLLABORATION.UPDATED"
            case .sharedLinkDeleted:
                return "SHARED_LINK.DELETED"
            case .sharedLinkCreated:
                return "SHARED_LINK.CREATED"
            case .sharedLinkUpdated:
                return "SHARED_LINK.UPDATED"
            case let .customValue(value):
                return value
            }
        }
    }

    // swiftlint:enable cyclomatic_complexity

    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]
    private static var resourceType: String = "webhook"
    // Box item type
    public var type: String

    // MARK: - Properties

    /// Identifier
    public let id: String
    // Target information
    public let target: WebhookItem?
    // User that created the webhook
    public let createdBy: User?
    // Timestamp of when webhook was created
    public let createdAt: Date?
    // URL to which notifications are sent
    public let address: URL?
    // Events that activate the webhook
    public let triggers: [EventTriggers]?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {

        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == Webhook.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [Webhook.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        target = try BoxJSONDecoder.optionalDecode(json: json, forKey: "target")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        address = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "address")
        triggers = try BoxJSONDecoder.optionalDecodeEnumCollection(json: json, forKey: "triggers")
    }
}
