import Foundation

/// The AppItem that triggered an event in the event stream.
public class AppItemEventSource: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case appItemType = "app_item_type"
        case type
        case user
        case group
    }

    /// The id of the `AppItem`
    public let id: String

    /// The type of the `AppItem`
    public let appItemType: String

    /// The type of the source that this event represents. Can only be `app_item`.
    /// 
    public let type: AppItemEventSourceTypeField

    public let user: UserMini?

    public let group: GroupMini?

    /// Initializer for a AppItemEventSource.
    ///
    /// - Parameters:
    ///   - id: The id of the `AppItem`
    ///   - appItemType: The type of the `AppItem`
    ///   - type: The type of the source that this event represents. Can only be `app_item`.
    ///     
    ///   - user: 
    ///   - group: 
    public init(id: String, appItemType: String, type: AppItemEventSourceTypeField = AppItemEventSourceTypeField.appItem, user: UserMini? = nil, group: GroupMini? = nil) {
        self.id = id
        self.appItemType = appItemType
        self.type = type
        self.user = user
        self.group = group
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        appItemType = try container.decode(String.self, forKey: .appItemType)
        type = try container.decode(AppItemEventSourceTypeField.self, forKey: .type)
        user = try container.decodeIfPresent(UserMini.self, forKey: .user)
        group = try container.decodeIfPresent(GroupMini.self, forKey: .group)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(appItemType, forKey: .appItemType)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encodeIfPresent(group, forKey: .group)
    }

}
