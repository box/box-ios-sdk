import Foundation

/// A browsable entry on the source or target system used to build shuttle
/// path mappings. Shared fields describe the node. `scope` is a
/// discriminated object that identifies the mapping namespace so a path
/// mapping can be created from this row without extra browse state.
public class ShuttlePathEntryV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case path
        case scope
        case isDirectory = "is_directory"
        case canMap = "can_map"
        case type
        case pathId = "path_id"
        case parentPath = "parent_path"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier of this browse row. This is not the account
    /// identifier; when `scope.type` is `account`, the account identifier is
    /// `scope.id`.
    public let id: String

    /// The display name of the path entry.
    public let name: String

    /// The human-readable path of the entry.
    public let path: String

    public let scope: ShuttlePathEntryScopeV2026R0

    /// Whether the entry is a directory (`true`) or a single file
    /// (`false`). Maps to `is_directory` on a path mapping location.
    public let isDirectory: Bool

    /// Whether the entry can be selected in a path mapping.
    public let canMap: Bool

    /// The value will always be `shuttle_path_entry`.
    public let type: ShuttlePathEntryV2026R0TypeField

    /// The system-native identifier of the path. `null` when the selected
    /// system does not provide one. Maps to `path_id` on a path mapping
    /// location.
    @CodableTriState public private(set) var pathId: String?

    /// The human-readable path of the parent entry, or `null` for a root
    /// entry.
    @CodableTriState public private(set) var parentPath: String?

    /// Initializer for a ShuttlePathEntryV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of this browse row. This is not the account
    ///     identifier; when `scope.type` is `account`, the account identifier is
    ///     `scope.id`.
    ///   - name: The display name of the path entry.
    ///   - path: The human-readable path of the entry.
    ///   - scope: 
    ///   - isDirectory: Whether the entry is a directory (`true`) or a single file
    ///     (`false`). Maps to `is_directory` on a path mapping location.
    ///   - canMap: Whether the entry can be selected in a path mapping.
    ///   - type: The value will always be `shuttle_path_entry`.
    ///   - pathId: The system-native identifier of the path. `null` when the selected
    ///     system does not provide one. Maps to `path_id` on a path mapping
    ///     location.
    ///   - parentPath: The human-readable path of the parent entry, or `null` for a root
    ///     entry.
    public init(id: String, name: String, path: String, scope: ShuttlePathEntryScopeV2026R0, isDirectory: Bool, canMap: Bool, type: ShuttlePathEntryV2026R0TypeField = ShuttlePathEntryV2026R0TypeField.shuttlePathEntry, pathId: TriStateField<String> = nil, parentPath: TriStateField<String> = nil) {
        self.id = id
        self.name = name
        self.path = path
        self.scope = scope
        self.isDirectory = isDirectory
        self.canMap = canMap
        self.type = type
        self._pathId = CodableTriState(state: pathId)
        self._parentPath = CodableTriState(state: parentPath)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        path = try container.decode(String.self, forKey: .path)
        scope = try container.decode(ShuttlePathEntryScopeV2026R0.self, forKey: .scope)
        isDirectory = try container.decode(Bool.self, forKey: .isDirectory)
        canMap = try container.decode(Bool.self, forKey: .canMap)
        type = try container.decode(ShuttlePathEntryV2026R0TypeField.self, forKey: .type)
        pathId = try container.decodeIfPresent(String.self, forKey: .pathId)
        parentPath = try container.decodeIfPresent(String.self, forKey: .parentPath)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(path, forKey: .path)
        try container.encode(scope, forKey: .scope)
        try container.encode(isDirectory, forKey: .isDirectory)
        try container.encode(canMap, forKey: .canMap)
        try container.encode(type, forKey: .type)
        try container.encode(field: _pathId.state, forKey: .pathId)
        try container.encode(field: _parentPath.state, forKey: .parentPath)
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
