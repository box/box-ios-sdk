import Foundation

public class SkillInvocationStatusField: Codable {
    private enum CodingKeys: String, CodingKey {
        case state
        case message
        case errorCode = "error_code"
        case additionalInfo = "additional_info"
    }

    /// The state of this event.
    /// 
    /// * `invoked` - Triggered the skill with event details to start
    ///   applying skill on the file.
    /// * `processing` - Currently processing.
    /// * `success` - Completed processing with a success.
    /// * `transient_failure` - Encountered an issue which can be
    ///   retried.
    /// * `permanent_failure` -  Encountered a permanent issue and
    ///   retry would not help.
    public let state: SkillInvocationStatusStateField?

    /// Status information
    public let message: String?

    /// Error code information, if error occurred.
    public let errorCode: String?

    /// Additional status information.
    public let additionalInfo: String?

    /// Initializer for a SkillInvocationStatusField.
    ///
    /// - Parameters:
    ///   - state: The state of this event.
    ///     
    ///     * `invoked` - Triggered the skill with event details to start
    ///       applying skill on the file.
    ///     * `processing` - Currently processing.
    ///     * `success` - Completed processing with a success.
    ///     * `transient_failure` - Encountered an issue which can be
    ///       retried.
    ///     * `permanent_failure` -  Encountered a permanent issue and
    ///       retry would not help.
    ///   - message: Status information
    ///   - errorCode: Error code information, if error occurred.
    ///   - additionalInfo: Additional status information.
    public init(state: SkillInvocationStatusStateField? = nil, message: String? = nil, errorCode: String? = nil, additionalInfo: String? = nil) {
        self.state = state
        self.message = message
        self.errorCode = errorCode
        self.additionalInfo = additionalInfo
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        state = try container.decodeIfPresent(SkillInvocationStatusStateField.self, forKey: .state)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        errorCode = try container.decodeIfPresent(String.self, forKey: .errorCode)
        additionalInfo = try container.decodeIfPresent(String.self, forKey: .additionalInfo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(errorCode, forKey: .errorCode)
        try container.encodeIfPresent(additionalInfo, forKey: .additionalInfo)
    }

}
