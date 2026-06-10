import Foundation

public enum AiTaxonomyReferenceTypeField: CodableStringEnum {
    case taxonomy
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "taxonomy".lowercased():
            self = .taxonomy
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .taxonomy:
            return "taxonomy"
        case .customValue(let value):
            return value
        }
    }

}
