import Foundation

public enum ShuttleJobCreateRequestV2026R0JobTypeField: CodableStringEnum {
    case transfer
    case analysis
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "transfer".lowercased():
            self = .transfer
        case "analysis".lowercased():
            self = .analysis
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .transfer:
            return "transfer"
        case .analysis:
            return "analysis"
        case .customValue(let value):
            return value
        }
    }

}
