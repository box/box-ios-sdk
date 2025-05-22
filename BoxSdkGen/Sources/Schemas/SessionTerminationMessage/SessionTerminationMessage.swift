import Foundation

/// A message informing about the
/// termination job status
public class SessionTerminationMessage: Codable {
    private enum CodingKeys: String, CodingKey {
        case message
    }

    /// The unique identifier for the termination job status
    public let message: String?

    /// Initializer for a SessionTerminationMessage.
    ///
    /// - Parameters:
    ///   - message: The unique identifier for the termination job status
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
