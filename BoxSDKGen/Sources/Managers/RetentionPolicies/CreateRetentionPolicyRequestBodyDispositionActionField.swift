import Foundation

public enum CreateRetentionPolicyRequestBodyDispositionActionField: CodableStringEnum {
    case permanentlyDelete
    case removeRetention
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "permanently_delete".lowercased():
            self = .permanentlyDelete
        case "remove_retention".lowercased():
            self = .removeRetention
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .permanentlyDelete:
            return "permanently_delete"
        case .removeRetention:
            return "remove_retention"
        case .customValue(let value):
            return value
        }
    }

}
