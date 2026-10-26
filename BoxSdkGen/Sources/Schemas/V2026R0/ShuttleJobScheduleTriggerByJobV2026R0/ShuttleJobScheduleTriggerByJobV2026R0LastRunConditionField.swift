import Foundation

public enum ShuttleJobScheduleTriggerByJobV2026R0LastRunConditionField: CodableStringEnum {
    case always
    case onSuccess
    case onFinish
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "always".lowercased():
            self = .always
        case "on_success".lowercased():
            self = .onSuccess
        case "on_finish".lowercased():
            self = .onFinish
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .always:
            return "always"
        case .onSuccess:
            return "on_success"
        case .onFinish:
            return "on_finish"
        case .customValue(let value):
            return value
        }
    }

}
