import Foundation

public enum WebhookInvocationTriggerField: CodableStringEnum {
    case fileUploaded
    case filePreviewed
    case fileDownloaded
    case fileTrashed
    case fileDeleted
    case fileRestored
    case fileCopied
    case fileMoved
    case fileLocked
    case fileUnlocked
    case fileRenamed
    case commentCreated
    case commentUpdated
    case commentDeleted
    case taskAssignmentCreated
    case taskAssignmentUpdated
    case metadataInstanceCreated
    case metadataInstanceUpdated
    case metadataInstanceDeleted
    case folderCreated
    case folderRenamed
    case folderDownloaded
    case folderRestored
    case folderDeleted
    case folderCopied
    case folderMoved
    case folderTrashed
    case webhookDeleted
    case collaborationCreated
    case collaborationAccepted
    case collaborationRejected
    case collaborationRemoved
    case collaborationUpdated
    case sharedLinkDeleted
    case sharedLinkCreated
    case sharedLinkUpdated
    case signRequestCompleted
    case signRequestDeclined
    case signRequestExpired
    case signRequestSignerEmailBounced
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "FILE.UPLOADED".lowercased():
            self = .fileUploaded
        case "FILE.PREVIEWED".lowercased():
            self = .filePreviewed
        case "FILE.DOWNLOADED".lowercased():
            self = .fileDownloaded
        case "FILE.TRASHED".lowercased():
            self = .fileTrashed
        case "FILE.DELETED".lowercased():
            self = .fileDeleted
        case "FILE.RESTORED".lowercased():
            self = .fileRestored
        case "FILE.COPIED".lowercased():
            self = .fileCopied
        case "FILE.MOVED".lowercased():
            self = .fileMoved
        case "FILE.LOCKED".lowercased():
            self = .fileLocked
        case "FILE.UNLOCKED".lowercased():
            self = .fileUnlocked
        case "FILE.RENAMED".lowercased():
            self = .fileRenamed
        case "COMMENT.CREATED".lowercased():
            self = .commentCreated
        case "COMMENT.UPDATED".lowercased():
            self = .commentUpdated
        case "COMMENT.DELETED".lowercased():
            self = .commentDeleted
        case "TASK_ASSIGNMENT.CREATED".lowercased():
            self = .taskAssignmentCreated
        case "TASK_ASSIGNMENT.UPDATED".lowercased():
            self = .taskAssignmentUpdated
        case "METADATA_INSTANCE.CREATED".lowercased():
            self = .metadataInstanceCreated
        case "METADATA_INSTANCE.UPDATED".lowercased():
            self = .metadataInstanceUpdated
        case "METADATA_INSTANCE.DELETED".lowercased():
            self = .metadataInstanceDeleted
        case "FOLDER.CREATED".lowercased():
            self = .folderCreated
        case "FOLDER.RENAMED".lowercased():
            self = .folderRenamed
        case "FOLDER.DOWNLOADED".lowercased():
            self = .folderDownloaded
        case "FOLDER.RESTORED".lowercased():
            self = .folderRestored
        case "FOLDER.DELETED".lowercased():
            self = .folderDeleted
        case "FOLDER.COPIED".lowercased():
            self = .folderCopied
        case "FOLDER.MOVED".lowercased():
            self = .folderMoved
        case "FOLDER.TRASHED".lowercased():
            self = .folderTrashed
        case "WEBHOOK.DELETED".lowercased():
            self = .webhookDeleted
        case "COLLABORATION.CREATED".lowercased():
            self = .collaborationCreated
        case "COLLABORATION.ACCEPTED".lowercased():
            self = .collaborationAccepted
        case "COLLABORATION.REJECTED".lowercased():
            self = .collaborationRejected
        case "COLLABORATION.REMOVED".lowercased():
            self = .collaborationRemoved
        case "COLLABORATION.UPDATED".lowercased():
            self = .collaborationUpdated
        case "SHARED_LINK.DELETED".lowercased():
            self = .sharedLinkDeleted
        case "SHARED_LINK.CREATED".lowercased():
            self = .sharedLinkCreated
        case "SHARED_LINK.UPDATED".lowercased():
            self = .sharedLinkUpdated
        case "SIGN_REQUEST.COMPLETED".lowercased():
            self = .signRequestCompleted
        case "SIGN_REQUEST.DECLINED".lowercased():
            self = .signRequestDeclined
        case "SIGN_REQUEST.EXPIRED".lowercased():
            self = .signRequestExpired
        case "SIGN_REQUEST.SIGNER_EMAIL_BOUNCED".lowercased():
            self = .signRequestSignerEmailBounced
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
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
            return "METADATA_INSTANCE.CREATED"
        case .metadataInstanceUpdated:
            return "METADATA_INSTANCE.UPDATED"
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
        case .signRequestCompleted:
            return "SIGN_REQUEST.COMPLETED"
        case .signRequestDeclined:
            return "SIGN_REQUEST.DECLINED"
        case .signRequestExpired:
            return "SIGN_REQUEST.EXPIRED"
        case .signRequestSignerEmailBounced:
            return "SIGN_REQUEST.SIGNER_EMAIL_BOUNCED"
        case .customValue(let value):
            return value
        }
    }

}
