import Foundation

public class TemplateSignerInputCoordinatesField: Codable {
    private enum CodingKeys: String, CodingKey {
        case x
        case y
    }

    /// Relative x coordinate to the page the input is on, ranging from 0 to 1.
    public let x: Double?

    /// Relative y coordinate to the page the input is on, ranging from 0 to 1.
    public let y: Double?

    /// Initializer for a TemplateSignerInputCoordinatesField.
    ///
    /// - Parameters:
    ///   - x: Relative x coordinate to the page the input is on, ranging from 0 to 1.
    ///   - y: Relative y coordinate to the page the input is on, ranging from 0 to 1.
    public init(x: Double? = nil, y: Double? = nil) {
        self.x = x
        self.y = y
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        x = try container.decodeIfPresent(Double.self, forKey: .x)
        y = try container.decodeIfPresent(Double.self, forKey: .y)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(x, forKey: .x)
        try container.encodeIfPresent(y, forKey: .y)
    }

}
