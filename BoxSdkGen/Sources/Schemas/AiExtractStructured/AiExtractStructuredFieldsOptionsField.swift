import Foundation

public class AiExtractStructuredFieldsOptionsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case key
    }

    /// A unique identifier for the field.
    public let key: String

    /// Initializer for a AiExtractStructuredFieldsOptionsField.
    ///
    /// - Parameters:
    ///   - key: A unique identifier for the field.
    public init(key: String) {
        self.key = key
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
    }

}
