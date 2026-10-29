import Foundation

/// One-time-passcode (OTP) settings for a shared link. When OTP enforcement
/// is enabled, anonymous users must verify their identity via a
/// one-time-passcode emailed to them before the shared link will grant
/// access.
/// 
/// OTP can only be used with shared links that have an `access` level of
/// `open`. Password protection and OTP cannot be enabled at the same time.
public enum SharedLinkOtpWritable: Codable {
    case sharedLinkOtpWritableAllowlist(SharedLinkOtpWritableAllowlist)
    case sharedLinkOtpWritableNone(SharedLinkOtpWritableNone)
    case sharedLinkOtpWritableOpen(SharedLinkOtpWritableOpen)

    public init(from decoder: Decoder) throws {
        if let content = try? SharedLinkOtpWritableAllowlist(from: decoder) {
            self = .sharedLinkOtpWritableAllowlist(content)
            return
        }

        if let content = try? SharedLinkOtpWritableNone(from: decoder) {
            self = .sharedLinkOtpWritableNone(content)
            return
        }

        if let content = try? SharedLinkOtpWritableOpen(from: decoder) {
            self = .sharedLinkOtpWritableOpen(content)
            return
        }

        throw DecodingError.typeMismatch(SharedLinkOtpWritable.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .sharedLinkOtpWritableAllowlist(let sharedLinkOtpWritableAllowlist):
            try sharedLinkOtpWritableAllowlist.encode(to: encoder)
        case .sharedLinkOtpWritableNone(let sharedLinkOtpWritableNone):
            try sharedLinkOtpWritableNone.encode(to: encoder)
        case .sharedLinkOtpWritableOpen(let sharedLinkOtpWritableOpen):
            try sharedLinkOtpWritableOpen.encode(to: encoder)
        }
    }

}
