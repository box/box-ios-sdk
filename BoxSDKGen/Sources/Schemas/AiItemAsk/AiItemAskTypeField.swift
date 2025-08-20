import Foundation

public enum AiItemAskTypeField: CodableStringEnum {
    case file
    case hubs
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "file".lowercased():
            self = .file
        case "hubs".lowercased():
            self = .hubs
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .file:
            return "file"
        case .hubs:
            return "hubs"
        case .customValue(let value):
            return value
        }
    }

}
