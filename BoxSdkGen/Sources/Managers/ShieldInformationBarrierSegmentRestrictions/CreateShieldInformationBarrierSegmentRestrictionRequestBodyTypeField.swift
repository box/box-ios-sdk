import Foundation

public enum CreateShieldInformationBarrierSegmentRestrictionRequestBodyTypeField: CodableStringEnum {
    case shieldInformationBarrierSegmentRestriction
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shield_information_barrier_segment_restriction".lowercased():
            self = .shieldInformationBarrierSegmentRestriction
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shieldInformationBarrierSegmentRestriction:
            return "shield_information_barrier_segment_restriction"
        case .customValue(let value):
            return value
        }
    }

}
