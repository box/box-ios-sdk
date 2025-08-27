import Foundation

public class UpdateStoragePolicyAssignmentByIdRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case storagePolicy = "storage_policy"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The storage policy to assign to the user or
    /// enterprise.
    public let storagePolicy: UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyField

    /// Initializer for a UpdateStoragePolicyAssignmentByIdRequestBody.
    ///
    /// - Parameters:
    ///   - storagePolicy: The storage policy to assign to the user or
    ///     enterprise.
    public init(storagePolicy: UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyField) {
        self.storagePolicy = storagePolicy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        storagePolicy = try container.decode(UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyField.self, forKey: .storagePolicy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(storagePolicy, forKey: .storagePolicy)
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
