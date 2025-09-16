import Foundation

public class CopyFolderRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case parent
        case name
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The destination folder to copy the folder to.
    public let parent: CopyFolderRequestBodyParentField

    /// An optional new name for the copied folder.
    /// 
    /// There are some restrictions to the file name. Names containing
    /// non-printable ASCII characters, forward and backward slashes
    /// (`/`, `\`), as well as names with trailing spaces are
    /// prohibited.
    /// 
    /// Additionally, the names `.` and `..` are
    /// not allowed either.
    public let name: String?

    /// Initializer for a CopyFolderRequestBody.
    ///
    /// - Parameters:
    ///   - parent: The destination folder to copy the folder to.
    ///   - name: An optional new name for the copied folder.
    ///     
    ///     There are some restrictions to the file name. Names containing
    ///     non-printable ASCII characters, forward and backward slashes
    ///     (`/`, `\`), as well as names with trailing spaces are
    ///     prohibited.
    ///     
    ///     Additionally, the names `.` and `..` are
    ///     not allowed either.
    public init(parent: CopyFolderRequestBodyParentField, name: String? = nil) {
        self.parent = parent
        self.name = name
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        parent = try container.decode(CopyFolderRequestBodyParentField.self, forKey: .parent)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(parent, forKey: .parent)
        try container.encodeIfPresent(name, forKey: .name)
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
