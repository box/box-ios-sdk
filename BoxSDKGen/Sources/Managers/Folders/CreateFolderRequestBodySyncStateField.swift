import Foundation

public enum CreateFolderRequestBodySyncStateField: CodableStringEnum {
    case synced
    case notSynced
    case partiallySynced
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "synced".lowercased():
            self = .synced
        case "not_synced".lowercased():
            self = .notSynced
        case "partially_synced".lowercased():
            self = .partiallySynced
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .synced:
            return "synced"
        case .notSynced:
            return "not_synced"
        case .partiallySynced:
            return "partially_synced"
        case .customValue(let value):
            return value
        }
    }

}
