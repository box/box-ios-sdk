import Foundation

public enum WebLinkSharedLinkEffectivePermissionField: CodableStringEnum {
    case canEdit
    case canDownload
    case canPreview
    case noAccess
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "can_edit".lowercased():
            self = .canEdit
        case "can_download".lowercased():
            self = .canDownload
        case "can_preview".lowercased():
            self = .canPreview
        case "no_access".lowercased():
            self = .noAccess
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .canEdit:
            return "can_edit"
        case .canDownload:
            return "can_download"
        case .canPreview:
            return "can_preview"
        case .noAccess:
            return "no_access"
        case .customValue(let value):
            return value
        }
    }

}
