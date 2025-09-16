import Foundation

public class CreateTermsOfServiceStatusForUserRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case tos
        case user
        case isAccepted = "is_accepted"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The terms of service to set the status for.
    public let tos: CreateTermsOfServiceStatusForUserRequestBodyTosField

    /// The user to set the status for.
    public let user: CreateTermsOfServiceStatusForUserRequestBodyUserField

    /// Whether the user has accepted the terms.
    public let isAccepted: Bool

    /// Initializer for a CreateTermsOfServiceStatusForUserRequestBody.
    ///
    /// - Parameters:
    ///   - tos: The terms of service to set the status for.
    ///   - user: The user to set the status for.
    ///   - isAccepted: Whether the user has accepted the terms.
    public init(tos: CreateTermsOfServiceStatusForUserRequestBodyTosField, user: CreateTermsOfServiceStatusForUserRequestBodyUserField, isAccepted: Bool) {
        self.tos = tos
        self.user = user
        self.isAccepted = isAccepted
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tos = try container.decode(CreateTermsOfServiceStatusForUserRequestBodyTosField.self, forKey: .tos)
        user = try container.decode(CreateTermsOfServiceStatusForUserRequestBodyUserField.self, forKey: .user)
        isAccepted = try container.decode(Bool.self, forKey: .isAccepted)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tos, forKey: .tos)
        try container.encode(user, forKey: .user)
        try container.encode(isAccepted, forKey: .isAccepted)
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
