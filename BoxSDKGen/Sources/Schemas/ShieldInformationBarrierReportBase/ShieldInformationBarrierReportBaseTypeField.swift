import Foundation

public enum ShieldInformationBarrierReportBaseTypeField: CodableStringEnum {
    case shieldInformationBarrierReport
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shield_information_barrier_report".lowercased():
            self = .shieldInformationBarrierReport
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shieldInformationBarrierReport:
            return "shield_information_barrier_report"
        case .customValue(let value):
            return value
        }
    }

}
