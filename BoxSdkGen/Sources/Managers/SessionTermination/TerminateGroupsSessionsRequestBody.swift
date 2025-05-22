import Foundation

public class TerminateGroupsSessionsRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case groupIds = "group_ids"
    }

    /// A list of group IDs
    public let groupIds: [String]

    /// Initializer for a TerminateGroupsSessionsRequestBody.
    ///
    /// - Parameters:
    ///   - groupIds: A list of group IDs
    public init(groupIds: [String]) {
        self.groupIds = groupIds
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        groupIds = try container.decode([String].self, forKey: .groupIds)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(groupIds, forKey: .groupIds)
    }

}
