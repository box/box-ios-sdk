import Foundation

public class ClientErrorV2025R0ContextInfoField: Codable {
    private enum CodingKeys: String, CodingKey {
        case message
    }

    /// More details on the error.
    public let message: String?

    /// Initializer for a ClientErrorV2025R0ContextInfoField.
    ///
    /// - Parameters:
    ///   - message: More details on the error.
    public init(message: String? = nil) {
        self.message = message
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(message, forKey: .message)
    }

}
