import Foundation

public enum ArchiveV2025R0TypeField: CodableStringEnum {
    case archive
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "archive".lowercased():
            self = .archive
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .archive:
            return "archive"
        case .customValue(let value):
            return value
        }
    }

}
