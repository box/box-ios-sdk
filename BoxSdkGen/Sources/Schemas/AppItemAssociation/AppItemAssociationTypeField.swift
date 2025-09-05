import Foundation

public enum AppItemAssociationTypeField: CodableStringEnum {
    case appItemAssociation
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "app_item_association".lowercased():
            self = .appItemAssociation
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .appItemAssociation:
            return "app_item_association"
        case .customValue(let value):
            return value
        }
    }

}
