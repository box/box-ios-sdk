import Foundation

public enum FileVersionLegalHoldTypeField: CodableStringEnum {
    case fileVersionLegalHold
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "file_version_legal_hold".lowercased():
            self = .fileVersionLegalHold
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .fileVersionLegalHold:
            return "file_version_legal_hold"
        case .customValue(let value):
            return value
        }
    }

}
