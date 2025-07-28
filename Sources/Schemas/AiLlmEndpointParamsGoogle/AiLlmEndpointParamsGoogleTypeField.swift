import Foundation

public enum AiLlmEndpointParamsGoogleTypeField: CodableStringEnum {
    case googleParams
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "google_params".lowercased():
            self = .googleParams
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .googleParams:
            return "google_params"
        case .customValue(let value):
            return value
        }
    }

}
