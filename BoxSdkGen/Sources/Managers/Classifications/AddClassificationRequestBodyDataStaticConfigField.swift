import Foundation

public class AddClassificationRequestBodyDataStaticConfigField: Codable {
    private enum CodingKeys: String, CodingKey {
        case classification
    }

    /// Additional details for the classification.
    public let classification: AddClassificationRequestBodyDataStaticConfigClassificationField?

    /// Initializer for a AddClassificationRequestBodyDataStaticConfigField.
    ///
    /// - Parameters:
    ///   - classification: Additional details for the classification.
    public init(classification: AddClassificationRequestBodyDataStaticConfigClassificationField? = nil) {
        self.classification = classification
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classification = try container.decodeIfPresent(AddClassificationRequestBodyDataStaticConfigClassificationField.self, forKey: .classification)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(classification, forKey: .classification)
    }

}
