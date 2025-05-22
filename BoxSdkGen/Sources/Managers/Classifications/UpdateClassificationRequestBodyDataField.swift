import Foundation

public class UpdateClassificationRequestBodyDataField: Codable {
    private enum CodingKeys: String, CodingKey {
        case key
        case staticConfig
    }

    /// A new label for the classification, as it will be
    /// shown in the web and mobile interfaces.
    public let key: String

    /// A static configuration for the classification.
    public let staticConfig: UpdateClassificationRequestBodyDataStaticConfigField?

    /// Initializer for a UpdateClassificationRequestBodyDataField.
    ///
    /// - Parameters:
    ///   - key: A new label for the classification, as it will be
    ///     shown in the web and mobile interfaces.
    ///   - staticConfig: A static configuration for the classification.
    public init(key: String, staticConfig: UpdateClassificationRequestBodyDataStaticConfigField? = nil) {
        self.key = key
        self.staticConfig = staticConfig
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        staticConfig = try container.decodeIfPresent(UpdateClassificationRequestBodyDataStaticConfigField.self, forKey: .staticConfig)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encodeIfPresent(staticConfig, forKey: .staticConfig)
    }

}
