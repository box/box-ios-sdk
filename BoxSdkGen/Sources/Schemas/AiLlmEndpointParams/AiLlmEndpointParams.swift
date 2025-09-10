import Foundation

/// The parameters for the LLM endpoint specific to a model.
public enum AiLlmEndpointParams: Codable {
    case aiLlmEndpointParamsOpenAi(AiLlmEndpointParamsOpenAi)
    case aiLlmEndpointParamsGoogle(AiLlmEndpointParamsGoogle)
    case aiLlmEndpointParamsAws(AiLlmEndpointParamsAws)
    case aiLlmEndpointParamsIbm(AiLlmEndpointParamsIbm)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "openai_params":
                    if let content = try? AiLlmEndpointParamsOpenAi(from: decoder) {
                        self = .aiLlmEndpointParamsOpenAi(content)
                        return
                    }

                case "google_params":
                    if let content = try? AiLlmEndpointParamsGoogle(from: decoder) {
                        self = .aiLlmEndpointParamsGoogle(content)
                        return
                    }

                case "aws_params":
                    if let content = try? AiLlmEndpointParamsAws(from: decoder) {
                        self = .aiLlmEndpointParamsAws(content)
                        return
                    }

                case "ibm_params":
                    if let content = try? AiLlmEndpointParamsIbm(from: decoder) {
                        self = .aiLlmEndpointParamsIbm(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(AiLlmEndpointParams.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .aiLlmEndpointParamsOpenAi(let aiLlmEndpointParamsOpenAi):
            try aiLlmEndpointParamsOpenAi.encode(to: encoder)
        case .aiLlmEndpointParamsGoogle(let aiLlmEndpointParamsGoogle):
            try aiLlmEndpointParamsGoogle.encode(to: encoder)
        case .aiLlmEndpointParamsAws(let aiLlmEndpointParamsAws):
            try aiLlmEndpointParamsAws.encode(to: encoder)
        case .aiLlmEndpointParamsIbm(let aiLlmEndpointParamsIbm):
            try aiLlmEndpointParamsIbm.encode(to: encoder)
        }
    }

}
