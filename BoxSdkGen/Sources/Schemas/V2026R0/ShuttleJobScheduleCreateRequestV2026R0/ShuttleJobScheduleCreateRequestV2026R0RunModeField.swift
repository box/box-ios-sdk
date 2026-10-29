import Foundation

public enum ShuttleJobScheduleCreateRequestV2026R0RunModeField: CodableStringEnum {
    case transfer
    case simulation
    case analysis
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "transfer".lowercased():
            self = .transfer
        case "simulation".lowercased():
            self = .simulation
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
        case .analysis:
            return "analysis"
        case .customValue(let value):
            return value
        }
    }

}
