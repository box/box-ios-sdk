import Foundation

public enum FileFullSharedLinkPermissionOptionsField: CodableStringEnum {
    case canPreview
    case canDownload
    case canEdit
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "can_preview".lowercased():
            self = .canPreview
        case "can_download".lowercased():
            self = .canDownload
        case "can_edit".lowercased():
            self = .canEdit
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .canPreview:
            return "can_preview"
        case .canDownload:
            return "can_download"
        case .canEdit:
            return "can_edit"
        case .customValue(let value):
            return value
        }
    }

}
