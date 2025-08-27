import Foundation

public enum UpdateUserByIdRequestBodyStatusField: CodableStringEnum {
    case active
    case inactive
    case cannotDeleteEdit
    case cannotDeleteEditUpload
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "active".lowercased():
            self = .active
        case "inactive".lowercased():
            self = .inactive
        case "cannot_delete_edit".lowercased():
            self = .cannotDeleteEdit
        case "cannot_delete_edit_upload".lowercased():
            self = .cannotDeleteEditUpload
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case .cannotDeleteEdit:
            return "cannot_delete_edit"
        case .cannotDeleteEditUpload:
            return "cannot_delete_edit_upload"
        case .customValue(let value):
            return value
        }
    }

}
