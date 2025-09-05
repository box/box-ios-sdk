import Foundation

public enum ShieldInformationBarrierReportStatusField: CodableStringEnum {
    case pending
    case error
    case done
    case cancelled
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "pending".lowercased():
            self = .pending
        case "error".lowercased():
            self = .error
        case "done".lowercased():
            self = .done
        case "cancelled".lowercased():
            self = .cancelled
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .pending:
            return "pending"
        case .error:
            return "error"
        case .done:
            return "done"
        case .cancelled:
            return "cancelled"
        case .customValue(let value):
            return value
        }
    }

}
