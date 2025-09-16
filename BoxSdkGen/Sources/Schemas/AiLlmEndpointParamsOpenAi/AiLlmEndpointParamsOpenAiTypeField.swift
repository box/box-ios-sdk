import Foundation

public enum AiLlmEndpointParamsOpenAiTypeField: CodableStringEnum {
    case openaiParams
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "openai_params".lowercased():
            self = .openaiParams
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .openaiParams:
            return "openai_params"
        case .customValue(let value):
            return value
        }
    }

}
