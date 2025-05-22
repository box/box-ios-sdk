import Foundation

/// A message informing the user that document tags are still being processed.
public class DocGenTagsProcessingMessageV2025R0: Codable {
    private enum CodingKeys: String, CodingKey {
        case message
    }

    /// A message informing the user that document tags are still being processed.
    public let message: String

    /// Initializer for a DocGenTagsProcessingMessageV2025R0.
    ///
    /// - Parameters:
    ///   - message: A message informing the user that document tags are still being processed.
    public init(message: String) {
        self.message = message
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
    }

}
