import Foundation

public enum WeblinkReferenceV2025R0TypeField: CodableStringEnum {
    case weblink
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "weblink".lowercased():
            self = .weblink
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .weblink:
            return "weblink"
        case .customValue(let value):
            return value
        }
    }

}
