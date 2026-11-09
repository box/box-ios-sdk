import Foundation

public enum TemplateSignerVerificationMethodCacPivTypeField: CodableStringEnum {
    case cacPiv
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "cac_piv".lowercased():
            self = .cacPiv
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .cacPiv:
            return "cac_piv"
        case .customValue(let value):
            return value
        }
    }

}
