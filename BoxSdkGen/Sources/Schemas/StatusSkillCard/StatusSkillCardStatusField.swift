import Foundation

public class StatusSkillCardStatusField: Codable {
    private enum CodingKeys: String, CodingKey {
        case code
        case message
    }

    /// A code for the status of this Skill invocation. By
    /// default each of these will have their own accompanied
    /// messages. These can be adjusted by setting the `message`
    /// value on this object.
    public let code: StatusSkillCardStatusCodeField

    /// A custom message that can be provided with this status.
    /// This will be shown in the web app to the end user.
    public let message: String?

    /// Initializer for a StatusSkillCardStatusField.
    ///
    /// - Parameters:
    ///   - code: A code for the status of this Skill invocation. By
    ///     default each of these will have their own accompanied
    ///     messages. These can be adjusted by setting the `message`
    ///     value on this object.
    ///   - message: A custom message that can be provided with this status.
    ///     This will be shown in the web app to the end user.
    public init(code: StatusSkillCardStatusCodeField, message: String? = nil) {
        self.code = code
        self.message = message
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(StatusSkillCardStatusCodeField.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encodeIfPresent(message, forKey: .message)
    }

}
