import Foundation

public class UploadPartsOrderField: Codable {
    private enum CodingKeys: String, CodingKey {
        case by
        case direction
    }

    /// The field to order by
    public let by: String?

    /// The direction to order by, either ascending or descending
    public let direction: UploadPartsOrderDirectionField?

    /// Initializer for a UploadPartsOrderField.
    ///
    /// - Parameters:
    ///   - by: The field to order by
    ///   - direction: The direction to order by, either ascending or descending
    public init(by: String? = nil, direction: UploadPartsOrderDirectionField? = nil) {
        self.by = by
        self.direction = direction
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        by = try container.decodeIfPresent(String.self, forKey: .by)
        direction = try container.decodeIfPresent(UploadPartsOrderDirectionField.self, forKey: .direction)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(by, forKey: .by)
        try container.encodeIfPresent(direction, forKey: .direction)
    }

}
