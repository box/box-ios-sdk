import Foundation

public class MetadataQueryOrderByField: Codable {
    private enum CodingKeys: String, CodingKey {
        case fieldKey = "field_key"
        case direction
    }

    /// The metadata template field to order by.
    /// 
    /// The `field_key` represents the `key` value of a field from the
    /// metadata template being searched for.
    public let fieldKey: String?

    /// The direction to order by, either ascending or descending.
    /// 
    /// The `ordering` direction must be the same for each item in the
    /// array.
    public let direction: MetadataQueryOrderByDirectionField?

    /// Initializer for a MetadataQueryOrderByField.
    ///
    /// - Parameters:
    ///   - fieldKey: The metadata template field to order by.
    ///     
    ///     The `field_key` represents the `key` value of a field from the
    ///     metadata template being searched for.
    ///   - direction: The direction to order by, either ascending or descending.
    ///     
    ///     The `ordering` direction must be the same for each item in the
    ///     array.
    public init(fieldKey: String? = nil, direction: MetadataQueryOrderByDirectionField? = nil) {
        self.fieldKey = fieldKey
        self.direction = direction
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fieldKey = try container.decodeIfPresent(String.self, forKey: .fieldKey)
        direction = try container.decodeIfPresent(MetadataQueryOrderByDirectionField.self, forKey: .direction)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(fieldKey, forKey: .fieldKey)
        try container.encodeIfPresent(direction, forKey: .direction)
    }

}
