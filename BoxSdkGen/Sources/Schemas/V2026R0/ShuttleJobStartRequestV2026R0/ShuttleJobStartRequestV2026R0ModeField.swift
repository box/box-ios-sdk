import Foundation

public enum ShuttleJobStartRequestV2026R0ModeField: CodableStringEnum {
    case transfer
    case simulation
    case scan
    case analysis
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "transfer".lowercased():
            self = .transfer
        case "simulation".lowercased():
            self = .simulation
        case "scan".lowercased():
            self = .scan
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
        case .simulation:
            return "simulation"
        case .scan:
            return "scan"
        case .analysis:
            return "analysis"
        case .customValue(let value):
            return value
        }
    }

}
