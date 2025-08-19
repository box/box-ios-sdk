import Foundation

public enum AiLlmEndpointParamsIbmTypeField: CodableStringEnum {
    case ibmParams
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ibm_params".lowercased():
            self = .ibmParams
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .ibmParams:
            return "ibm_params"
        case .customValue(let value):
            return value
        }
    }

}
