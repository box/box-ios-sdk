import Foundation

/// Specifies opperations available on metadata template
public enum MetadataTemplateOperation {
    /// Adds an enum option at the end of the enum option list for the specified field.
    ///
    /// - Parameters:
    ///     - fieldKey: The key of the field to add the enum option. Must refer to an enum field.
    ///     - data: JSON object of the enum option to be added
    case addEnumOption(fieldKey: String, data: [String: Any])

    /// Adds a field at the end of the field list for the template.
    ///
    /// - Parameters:
    ///     - data: JSON object of the enum option to be added
    case addField(data: [String: Any])

    /// Edits any number of the base properties of a template: displayName, hidden.
    ///
    /// - Parameters:
    ///     - data: JSON object of the properties to be changed and their new values.
    case editTemplate(data: [String: Any])

    /// Reorders the enum option list to match the requested enum option list.
    ///
    /// - Parameters:
    ///     - fieldKey: The key of the field to reorder enum options. Must refer to an enum field.
    ///     - enumOptionKeys: The new list of enum option keys in the requested order.
    case reorderEnumOptions(fieldKey: String, enumOptionKeys: [String])

    /// Reorders the field list to match the requested field list
    ///
    /// - Parameters:
    ///     - fieldKey: The new list of field keys in the requested order.
    case reorderFields(fieldKeys: [String])

    /// Edits any number of the base properties of a field: displayName, hidden, description, key.
    ///
    /// - Parameters:
    ///     - fieldKey: The key of the field to be edited.
    ///     - data: JSON object of the properties to be changed and their new values.
    case editField(fieldKey: String, data: [String: Any])

    /// Edits the enumOption.
    ///
    /// - Parameters:
    ///     - fieldKey: The key of the field the specified enum option belongs to. Must refer to an enum field.
    ///     - data: JSON object with the new key of the enumOption.
    ///     - enumOptionKey: The key of the enum option to be edited.
    case editEnumOption(fieldKey: String, data: [String: Any], enumOptionKey: String)

    /// Removes the specified enum option from the specified enum field.
    ///
    /// - Parameters:
    ///     - fieldKey: The key of the field from which the enum option should be removed. Must refer to an enum field.
    ///     - enumOptionKeys: The key of the enum option to be removed.
    case removeEnumOption(fieldKey: String, enumOptionKey: String)

    /// Removes the specified field from the template
    ///
    /// - Parameters:
    ///     - fieldKey: The key of the field to be removed.
    case removeField(fieldKey: String)

    /// Creates JSON dictionary representation of an option.
    ///
    /// - Returns: JSON dictionary representation of an option.
    public func json() -> [String: Any] {
        switch self {
        case let .addEnumOption(fieldKey, data):
            return ["op": "addEnumOption", "fieldKey": fieldKey, "data": data]
        case let .addField(data):
            return ["op": "addField", "data": data]
        case let .editTemplate(data):
            return ["op": "editTemplate", "data": data]
        case let .reorderEnumOptions(fieldKey, enumOptionKeys):
            return ["op": "reorderEnumOptions", "fieldKey": fieldKey, "enumOptionKeys": enumOptionKeys]
        case let .reorderFields(fieldKeys):
            return ["op": "reorderFields", "fieldKeys": fieldKeys]
        case let .editField(fieldKey, data):
            return ["op": "editField", "fieldKey": fieldKey, "data": data]
        case let .editEnumOption(fieldKey, data, enumOptionKey):
            return ["op": "editEnumOption", "fieldKey": fieldKey, "data": data, "enumOptionKey": enumOptionKey]
        case let .removeEnumOption(fieldKey, enumOptionKey):
            return ["op": "removeEnumOption", "fieldKey": fieldKey, "enumOptionKey": enumOptionKey]
        case let .removeField(fieldKey):
            return ["op": "removeField", "fieldKey": fieldKey]
        }
    }
}

/// Metadata that belongs to a file or folder is grouped by templates.
/// Templates allow the metadata service to provide a multitude of services,
/// such as pre-defining sets of key:value pairs or schema enforcement on specific fields.
public class MetadataTemplate: BoxModel {

    // MARK: - Properties

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String?
    /// A unique identifier for the template. The identifier must be unique across the scope of the enterprise to which the metadata template is being applied.
    public let templateKey: String?
    /// The scope of the object. Global and enterprise scopes are supported.
    /// The Global scope contains the properties template, while the enterprise scope pertains to custom template within the enterprise.
    public let scope: String?
    /// The display name of the template.
    public let displayName: String?
    /// Whether this template is hidden in the UI.
    public let hidden: Bool?
    /// The ordered set of key:value pairs for the template.
    public let fields: [MetadataField]?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        id = try BoxJSONDecoder.optionalDecode(json: json, forKey: "id")
        templateKey = try BoxJSONDecoder.optionalDecode(json: json, forKey: "templateKey")
        scope = try BoxJSONDecoder.optionalDecode(json: json, forKey: "scope")
        displayName = try BoxJSONDecoder.optionalDecode(json: json, forKey: "displayName")
        hidden = try BoxJSONDecoder.optionalDecode(json: json, forKey: "hidden")
        fields = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "fields")
    }
}
