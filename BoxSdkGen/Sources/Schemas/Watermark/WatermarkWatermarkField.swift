import Foundation

public class WatermarkWatermarkField: Codable {
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }

    /// When this watermark was created
    public let createdAt: Date?

    /// When this task was modified
    public let modifiedAt: Date?

    /// Initializer for a WatermarkWatermarkField.
    ///
    /// - Parameters:
    ///   - createdAt: When this watermark was created
    ///   - modifiedAt: When this task was modified
    public init(createdAt: Date? = nil, modifiedAt: Date? = nil) {
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
    }

}
