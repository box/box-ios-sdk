import Foundation

public enum StoragePolicyMiniTypeField: CodableStringEnum {
    case storagePolicy
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "storage_policy".lowercased():
            self = .storagePolicy
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .storagePolicy:
            return "storage_policy"
        case .customValue(let value):
            return value
        }
    }

}
