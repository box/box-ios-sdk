import Foundation

public class AiAgentInfoModelsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case provider
        case supportedPurpose = "supported_purpose"
    }

    /// The name of the model used for the request
    public let name: String?

    /// The provider that owns the model used for the request
    public let provider: String?

    /// The supported purpose utilized by the model used for the request
    public let supportedPurpose: String?

    /// Initializer for a AiAgentInfoModelsField.
    ///
    /// - Parameters:
    ///   - name: The name of the model used for the request
    ///   - provider: The provider that owns the model used for the request
    ///   - supportedPurpose: The supported purpose utilized by the model used for the request
    public init(name: String? = nil, provider: String? = nil, supportedPurpose: String? = nil) {
        self.name = name
        self.provider = provider
        self.supportedPurpose = supportedPurpose
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        provider = try container.decodeIfPresent(String.self, forKey: .provider)
        supportedPurpose = try container.decodeIfPresent(String.self, forKey: .supportedPurpose)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(provider, forKey: .provider)
        try container.encodeIfPresent(supportedPurpose, forKey: .supportedPurpose)
    }

}
