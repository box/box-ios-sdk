import Foundation

/// A message informing the user that document tags are still being processed.
public class DocGenTagsProcessingMessageV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case message
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
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
