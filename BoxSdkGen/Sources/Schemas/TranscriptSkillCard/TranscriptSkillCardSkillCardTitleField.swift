import Foundation

public class TranscriptSkillCardSkillCardTitleField: Codable {
    private enum CodingKeys: String, CodingKey {
        case message
        case code
    }

    /// The actual title to show in the UI.
    public let message: String

    /// An optional identifier for the title.
    public let code: String?

    /// Initializer for a TranscriptSkillCardSkillCardTitleField.
    ///
    /// - Parameters:
    ///   - message: The actual title to show in the UI.
    ///   - code: An optional identifier for the title.
    public init(message: String, code: String? = nil) {
        self.message = message
        self.code = code
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        code = try container.decodeIfPresent(String.self, forKey: .code)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encodeIfPresent(code, forKey: .code)
    }

}
