import Foundation

/// A relation between a resource (file or folder) and the scopes for which the resource can be accessed.
public class FileOrFolderScope: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case scope
        case object
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The scopes for the resource access.
    public let scope: FileOrFolderScopeScopeField?

    public let object: FileMiniOrFolderMini?

    /// Initializer for a FileOrFolderScope.
    ///
    /// - Parameters:
    ///   - scope: The scopes for the resource access.
    ///   - object: 
    public init(scope: FileOrFolderScopeScopeField? = nil, object: FileMiniOrFolderMini? = nil) {
        self.scope = scope
        self.object = object
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scope = try container.decodeIfPresent(FileOrFolderScopeScopeField.self, forKey: .scope)
        object = try container.decodeIfPresent(FileMiniOrFolderMini.self, forKey: .object)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(scope, forKey: .scope)
        try container.encodeIfPresent(object, forKey: .object)
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
