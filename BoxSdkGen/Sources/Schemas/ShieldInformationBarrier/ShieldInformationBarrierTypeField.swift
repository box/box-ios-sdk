import Foundation

public enum ShieldInformationBarrierTypeField: CodableStringEnum {
    case shieldInformationBarrier
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shield_information_barrier".lowercased():
            self = .shieldInformationBarrier
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shieldInformationBarrier:
            return "shield_information_barrier"
        case .customValue(let value):
            return value
        }
    }

}
