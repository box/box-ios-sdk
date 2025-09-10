import Foundation

public enum ClientErrorCodeField: CodableStringEnum {
    case created
    case accepted
    case noContent
    case redirect
    case notModified
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case methodNotAllowed
    case conflict
    case preconditionFailed
    case tooManyRequests
    case internalServerError
    case unavailable
    case itemNameInvalid
    case insufficientScope
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "created".lowercased():
            self = .created
        case "accepted".lowercased():
            self = .accepted
        case "no_content".lowercased():
            self = .noContent
        case "redirect".lowercased():
            self = .redirect
        case "not_modified".lowercased():
            self = .notModified
        case "bad_request".lowercased():
            self = .badRequest
        case "unauthorized".lowercased():
            self = .unauthorized
        case "forbidden".lowercased():
            self = .forbidden
        case "not_found".lowercased():
            self = .notFound
        case "method_not_allowed".lowercased():
            self = .methodNotAllowed
        case "conflict".lowercased():
            self = .conflict
        case "precondition_failed".lowercased():
            self = .preconditionFailed
        case "too_many_requests".lowercased():
            self = .tooManyRequests
        case "internal_server_error".lowercased():
            self = .internalServerError
        case "unavailable".lowercased():
            self = .unavailable
        case "item_name_invalid".lowercased():
            self = .itemNameInvalid
        case "insufficient_scope".lowercased():
            self = .insufficientScope
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .created:
            return "created"
        case .accepted:
            return "accepted"
        case .noContent:
            return "no_content"
        case .redirect:
            return "redirect"
        case .notModified:
            return "not_modified"
        case .badRequest:
            return "bad_request"
        case .unauthorized:
            return "unauthorized"
        case .forbidden:
            return "forbidden"
        case .notFound:
            return "not_found"
        case .methodNotAllowed:
            return "method_not_allowed"
        case .conflict:
            return "conflict"
        case .preconditionFailed:
            return "precondition_failed"
        case .tooManyRequests:
            return "too_many_requests"
        case .internalServerError:
            return "internal_server_error"
        case .unavailable:
            return "unavailable"
        case .itemNameInvalid:
            return "item_name_invalid"
        case .insufficientScope:
            return "insufficient_scope"
        case .customValue(let value):
            return value
        }
    }

}
