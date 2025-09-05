import Foundation

public enum UpdateMetadataTemplateRequestBodyOpField: CodableStringEnum {
    case editTemplate
    case addField
    case reorderFields
    case addEnumOption
    case reorderEnumOptions
    case reorderMultiSelectOptions
    case addMultiSelectOption
    case editField
    case removeField
    case editEnumOption
    case removeEnumOption
    case editMultiSelectOption
    case removeMultiSelectOption
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "editTemplate".lowercased():
            self = .editTemplate
        case "addField".lowercased():
            self = .addField
        case "reorderFields".lowercased():
            self = .reorderFields
        case "addEnumOption".lowercased():
            self = .addEnumOption
        case "reorderEnumOptions".lowercased():
            self = .reorderEnumOptions
        case "reorderMultiSelectOptions".lowercased():
            self = .reorderMultiSelectOptions
        case "addMultiSelectOption".lowercased():
            self = .addMultiSelectOption
        case "editField".lowercased():
            self = .editField
        case "removeField".lowercased():
            self = .removeField
        case "editEnumOption".lowercased():
            self = .editEnumOption
        case "removeEnumOption".lowercased():
            self = .removeEnumOption
        case "editMultiSelectOption".lowercased():
            self = .editMultiSelectOption
        case "removeMultiSelectOption".lowercased():
            self = .removeMultiSelectOption
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .editTemplate:
            return "editTemplate"
        case .addField:
            return "addField"
        case .reorderFields:
            return "reorderFields"
        case .addEnumOption:
            return "addEnumOption"
        case .reorderEnumOptions:
            return "reorderEnumOptions"
        case .reorderMultiSelectOptions:
            return "reorderMultiSelectOptions"
        case .addMultiSelectOption:
            return "addMultiSelectOption"
        case .editField:
            return "editField"
        case .removeField:
            return "removeField"
        case .editEnumOption:
            return "editEnumOption"
        case .removeEnumOption:
            return "removeEnumOption"
        case .editMultiSelectOption:
            return "editMultiSelectOption"
        case .removeMultiSelectOption:
            return "removeMultiSelectOption"
        case .customValue(let value):
            return value
        }
    }

}
