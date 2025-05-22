import Foundation

public class UpdateCommentByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case message
    }

    /// The text of the comment to update
    public let message: String?

    /// Initializer for a UpdateCommentByIdRequestBody.
    ///
    /// - Parameters:
    ///   - message: The text of the comment to update
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
