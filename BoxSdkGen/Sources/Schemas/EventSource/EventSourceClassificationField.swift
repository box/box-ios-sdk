import Foundation

public class EventSourceClassificationField: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
    }

    /// The classification's name
    public let name: String?

    /// Initializer for a EventSourceClassificationField.
    ///
    /// - Parameters:
    ///   - name: The classification's name
    public init(name: String? = nil) {
        self.name = name
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
    }

}
