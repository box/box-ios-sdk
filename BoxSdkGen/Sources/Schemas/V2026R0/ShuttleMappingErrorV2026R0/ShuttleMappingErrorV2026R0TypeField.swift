import Foundation

public enum ShuttleMappingErrorV2026R0TypeField: CodableStringEnum {
    case shuttleMappingError
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shuttle_mapping_error".lowercased():
            self = .shuttleMappingError
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shuttleMappingError:
            return "shuttle_mapping_error"
        case .customValue(let value):
            return value
        }
    }

}
