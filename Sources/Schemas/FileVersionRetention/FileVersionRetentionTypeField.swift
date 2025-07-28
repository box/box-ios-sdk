import Foundation

public enum FileVersionRetentionTypeField: CodableStringEnum {
    case fileVersionRetention
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "file_version_retention".lowercased():
            self = .fileVersionRetention
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .fileVersionRetention:
            return "file_version_retention"
        case .customValue(let value):
            return value
        }
    }

}
