import Foundation

public enum ShieldListContentCountryV2025R0TypeField: CodableStringEnum {
    case country
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "country".lowercased():
            self = .country
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .country:
            return "country"
        case .customValue(let value):
            return value
        }
    }

}
