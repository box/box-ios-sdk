import Foundation

public enum AiLlmEndpointParamsAwsTypeField: CodableStringEnum {
    case awsParams
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "aws_params".lowercased():
            self = .awsParams
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .awsParams:
            return "aws_params"
        case .customValue(let value):
            return value
        }
    }

}
