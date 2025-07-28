import Foundation

public enum FolderFullAllowedInviteeRolesField: CodableStringEnum {
    case editor
    case viewer
    case previewer
    case uploader
    case previewerUploader
    case viewerUploader
    case coOwner
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "editor".lowercased():
            self = .editor
        case "viewer".lowercased():
            self = .viewer
        case "previewer".lowercased():
            self = .previewer
        case "uploader".lowercased():
            self = .uploader
        case "previewer uploader".lowercased():
            self = .previewerUploader
        case "viewer uploader".lowercased():
            self = .viewerUploader
        case "co-owner".lowercased():
            self = .coOwner
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .editor:
            return "editor"
        case .viewer:
            return "viewer"
        case .previewer:
            return "previewer"
        case .uploader:
            return "uploader"
        case .previewerUploader:
            return "previewer uploader"
        case .viewerUploader:
            return "viewer uploader"
        case .coOwner:
            return "co-owner"
        case .customValue(let value):
            return value
        }
    }

}
