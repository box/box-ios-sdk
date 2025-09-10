import Foundation

public enum UpdateMetadataTemplateScope: CodableStringEnum {
    case global
    case enterprise
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "global".lowercased():
            self = .global
        case "enterprise".lowercased():
            self = .enterprise
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .global:
            return "global"
        case .enterprise:
            return "enterprise"
        case .customValue(let value):
            return value
        }
    }

}
