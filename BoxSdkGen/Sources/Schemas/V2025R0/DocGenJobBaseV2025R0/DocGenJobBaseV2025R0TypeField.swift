import Foundation

public enum DocGenJobBaseV2025R0TypeField: CodableStringEnum {
    case docgenJob
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "docgen_job".lowercased():
            self = .docgenJob
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .docgenJob:
            return "docgen_job"
        case .customValue(let value):
            return value
        }
    }

}
