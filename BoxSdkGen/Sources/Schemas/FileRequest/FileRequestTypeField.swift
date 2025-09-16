import Foundation

public enum FileRequestTypeField: CodableStringEnum {
    case fileRequest
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "file_request".lowercased():
            self = .fileRequest
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .fileRequest:
            return "file_request"
        case .customValue(let value):
            return value
        }
    }

}
