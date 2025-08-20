import Foundation

public class CreateCollaborationWhitelistExemptTargetRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case user
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The user to exempt.
    public let user: CreateCollaborationWhitelistExemptTargetRequestBodyUserField

    /// Initializer for a CreateCollaborationWhitelistExemptTargetRequestBody.
    ///
    /// - Parameters:
    ///   - user: The user to exempt.
    public init(user: CreateCollaborationWhitelistExemptTargetRequestBodyUserField) {
        self.user = user
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(CreateCollaborationWhitelistExemptTargetRequestBodyUserField.self, forKey: .user)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(user, forKey: .user)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
