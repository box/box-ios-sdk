import Foundation

public enum ShuttleSubjectMappingV2026R0TypeField: CodableStringEnum {
    case shuttleSubjectMapping
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shuttle_subject_mapping".lowercased():
            self = .shuttleSubjectMapping
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shuttleSubjectMapping:
            return "shuttle_subject_mapping"
        case .customValue(let value):
            return value
        }
    }

}
