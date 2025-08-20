import Foundation

public enum WorkflowFlowsOutcomesActionTypeField: CodableStringEnum {
    case addMetadata
    case assignTask
    case copyFile
    case copyFolder
    case createFolder
    case deleteFile
    case deleteFolder
    case lockFile
    case moveFile
    case moveFolder
    case removeWatermarkFile
    case renameFolder
    case restoreFolder
    case shareFile
    case shareFolder
    case unlockFile
    case uploadFile
    case waitForTask
    case watermarkFile
    case goBackToStep
    case applyFileClassification
    case applyFolderClassification
    case sendNotification
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "add_metadata".lowercased():
            self = .addMetadata
        case "assign_task".lowercased():
            self = .assignTask
        case "copy_file".lowercased():
            self = .copyFile
        case "copy_folder".lowercased():
            self = .copyFolder
        case "create_folder".lowercased():
            self = .createFolder
        case "delete_file".lowercased():
            self = .deleteFile
        case "delete_folder".lowercased():
            self = .deleteFolder
        case "lock_file".lowercased():
            self = .lockFile
        case "move_file".lowercased():
            self = .moveFile
        case "move_folder".lowercased():
            self = .moveFolder
        case "remove_watermark_file".lowercased():
            self = .removeWatermarkFile
        case "rename_folder".lowercased():
            self = .renameFolder
        case "restore_folder".lowercased():
            self = .restoreFolder
        case "share_file".lowercased():
            self = .shareFile
        case "share_folder".lowercased():
            self = .shareFolder
        case "unlock_file".lowercased():
            self = .unlockFile
        case "upload_file".lowercased():
            self = .uploadFile
        case "wait_for_task".lowercased():
            self = .waitForTask
        case "watermark_file".lowercased():
            self = .watermarkFile
        case "go_back_to_step".lowercased():
            self = .goBackToStep
        case "apply_file_classification".lowercased():
            self = .applyFileClassification
        case "apply_folder_classification".lowercased():
            self = .applyFolderClassification
        case "send_notification".lowercased():
            self = .sendNotification
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .addMetadata:
            return "add_metadata"
        case .assignTask:
            return "assign_task"
        case .copyFile:
            return "copy_file"
        case .copyFolder:
            return "copy_folder"
        case .createFolder:
            return "create_folder"
        case .deleteFile:
            return "delete_file"
        case .deleteFolder:
            return "delete_folder"
        case .lockFile:
            return "lock_file"
        case .moveFile:
            return "move_file"
        case .moveFolder:
            return "move_folder"
        case .removeWatermarkFile:
            return "remove_watermark_file"
        case .renameFolder:
            return "rename_folder"
        case .restoreFolder:
            return "restore_folder"
        case .shareFile:
            return "share_file"
        case .shareFolder:
            return "share_folder"
        case .unlockFile:
            return "unlock_file"
        case .uploadFile:
            return "upload_file"
        case .waitForTask:
            return "wait_for_task"
        case .watermarkFile:
            return "watermark_file"
        case .goBackToStep:
            return "go_back_to_step"
        case .applyFileClassification:
            return "apply_file_classification"
        case .applyFolderClassification:
            return "apply_folder_classification"
        case .sendNotification:
            return "send_notification"
        case .customValue(let value):
            return value
        }
    }

}
