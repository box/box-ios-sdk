import Foundation

public enum ShieldInformationBarrierSegmentMemberBaseTypeField: CodableStringEnum {
    case shieldInformationBarrierSegmentMember
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shield_information_barrier_segment_member".lowercased():
            self = .shieldInformationBarrierSegmentMember
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shieldInformationBarrierSegmentMember:
            return "shield_information_barrier_segment_member"
        case .customValue(let value):
            return value
        }
    }

}
