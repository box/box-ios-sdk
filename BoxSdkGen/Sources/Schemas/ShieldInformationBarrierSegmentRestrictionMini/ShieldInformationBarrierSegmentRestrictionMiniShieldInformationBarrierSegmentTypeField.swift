import Foundation

public enum ShieldInformationBarrierSegmentRestrictionMiniShieldInformationBarrierSegmentTypeField: CodableStringEnum {
    case shieldInformationBarrierSegment
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shield_information_barrier_segment".lowercased():
            self = .shieldInformationBarrierSegment
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shieldInformationBarrierSegment:
            return "shield_information_barrier_segment"
        case .customValue(let value):
            return value
        }
    }

}
