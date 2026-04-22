import Foundation

/// The maximum extension length of the retention date.
/// This value specifies the duration in days for which
/// the retention date of the file under policy can be extended.
/// If the policy type is other than 'finite' or
/// the disposition action is other than 'permanently delete',
/// or the maximum extension length is undefined,
/// this field will be set to 'none'.
public enum RetentionPolicyMaxExtensionLengthResponse: Codable {
    case retentionPolicyMaxExtensionLengthResponseEnum(RetentionPolicyMaxExtensionLengthResponseEnum)
    case string(String)

    public init(from decoder: Decoder) throws {
        if let content = try? RetentionPolicyMaxExtensionLengthResponseEnum(from: decoder) {
            self = .retentionPolicyMaxExtensionLengthResponseEnum(content)
            return
        }

        if let content = try? String(from: decoder) {
            self = .string(content)
            return
        }

        throw DecodingError.typeMismatch(RetentionPolicyMaxExtensionLengthResponse.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .retentionPolicyMaxExtensionLengthResponseEnum(let retentionPolicyMaxExtensionLengthResponseEnum):
            try retentionPolicyMaxExtensionLengthResponseEnum.encode(to: encoder)
        case .string(let string):
            try string.encode(to: encoder)
        }
    }

}
