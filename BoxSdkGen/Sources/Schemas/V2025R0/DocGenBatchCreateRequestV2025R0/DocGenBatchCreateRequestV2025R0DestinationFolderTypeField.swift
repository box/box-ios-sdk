import Foundation

public enum DocGenBatchCreateRequestV2025R0DestinationFolderTypeField: CodableStringEnum {
    case folder
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "folder".lowercased():
            self = .folder
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .folder:
            return "folder"
        case .customValue(let value):
            return value
        }
    }

}
