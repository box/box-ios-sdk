import Foundation

public enum ShieldListContentDomainV2025R0TypeField: CodableStringEnum {
    case domain
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "domain".lowercased():
            self = .domain
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .domain:
            return "domain"
        case .customValue(let value):
            return value
        }
    }

}
