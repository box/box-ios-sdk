import Foundation

/// The maximum extension length of the retention date.
/// This value specifies the duration in days for which
/// the retention date of the file under policy can be extended.
/// It can be specified only for the 'finite' policy type
/// where the disposition action is 'permanently delete',
/// otherwise the server will return status 400.
/// If this value is 'none', it won't be possible to extend
/// the retention.
public enum RetentionPolicyMaxExtensionLengthRequest: Codable {
    case int(Int)
    case retentionPolicyMaxExtensionLengthRequestEnum(RetentionPolicyMaxExtensionLengthRequestEnum)
    case string(String)

    public init(from decoder: Decoder) throws {
        if let content = try? Int(from: decoder) {
            self = .int(content)
            return
        }

        if let content = try? RetentionPolicyMaxExtensionLengthRequestEnum(from: decoder) {
            self = .retentionPolicyMaxExtensionLengthRequestEnum(content)
            return
        }

        if let content = try? String(from: decoder) {
            self = .string(content)
            return
        }

        throw DecodingError.typeMismatch(RetentionPolicyMaxExtensionLengthRequest.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .int(let int):
            try int.encode(to: encoder)
        case .retentionPolicyMaxExtensionLengthRequestEnum(let retentionPolicyMaxExtensionLengthRequestEnum):
            try retentionPolicyMaxExtensionLengthRequestEnum.encode(to: encoder)
        case .string(let string):
            try string.encode(to: encoder)
        }
    }

}
