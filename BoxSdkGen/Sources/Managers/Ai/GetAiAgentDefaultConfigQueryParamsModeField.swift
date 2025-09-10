import Foundation

public enum GetAiAgentDefaultConfigQueryParamsModeField: CodableStringEnum {
    case ask
    case textGen
    case extract
    case extractStructured
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ask".lowercased():
            self = .ask
        case "text_gen".lowercased():
            self = .textGen
        case "extract".lowercased():
            self = .extract
        case "extract_structured".lowercased():
            self = .extractStructured
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .ask:
            return "ask"
        case .textGen:
            return "text_gen"
        case .extract:
            return "extract"
        case .extractStructured:
            return "extract_structured"
        case .customValue(let value):
            return value
        }
    }

}
