import Foundation

public enum CreateCollaborationRequestBodyItemTypeField: CodableStringEnum {
    case file
    case folder
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "file".lowercased():
            self = .file
        case "folder".lowercased():
            self = .folder
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .file:
            return "file"
        case .folder:
            return "folder"
        case .customValue(let value):
            return value
        }
    }

}
