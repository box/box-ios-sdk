import Foundation

public enum ShieldListMiniV2025R0TypeField: CodableStringEnum {
    case shieldList
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "shield_list".lowercased():
            self = .shieldList
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .shieldList:
            return "shield_list"
        case .customValue(let value):
            return value
        }
    }

}
