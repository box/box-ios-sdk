//
//  MetadataSearchFilter.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 7/16/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Defines the the relation between the filter key and filter value of a metadata template.
public enum MetadataFilterBound {
    /// Inclusive upper bound parameter for field values of floats and dates.
    case lessThan
    /// Inclusive lower bound parameter for field values of floats and dates.
    case greaterThan
    /// Set the filter value equal to filter key.
    case equal
}

/// Defines the scope of the metadata template.
public enum MetadataScope: BoxEnum {
    /// The scope of the metadata template is set to the entire "enterprise".
    case enterprise
    /// The scope of the metadata template is set to "global"
    case global
    /// A custom scope for metadata template.
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "enterprise":
            self = .enterprise
        case "global":
            self = .global
        default:
            self = .customValue(value)
        }
    }

    public init(from decoder: Decoder) throws {
        var stringVal: String

        do {
            let container = try decoder.singleValueContainer()
            stringVal = try container.decode(String.self)
        }
        catch {
            throw BoxCodingError(error: error)
        }

        self = MetadataScope(stringVal)
    }

    public var description: String {

        switch self {
        case .enterprise:
            return "enterprise"
        case .global:
            return "global"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Represents the filter object on the Metadata Search Filter.
struct FilterStruct {
    var fieldKey: String
    var fieldValue: String
    var relation: MetadataFilterBound
}

/// Represents the Metadata Search Filter entries.
struct MetadataSearchFilterElement: Encodable {
    let templateKey: String
    let scope: MetadataScope
    var filters: [FilterStruct]

    /// Initializer
    ///
    /// - Parameters:
    ///   - templateKey: The key of the metadata template.
    ///   - scope: The scope of the metadata template.
    init(templateKey: String, scope: MetadataScope) {
        self.templateKey = templateKey
        self.scope = scope
        filters = []
    }

    /// Adds a new filter struct to our list of structs.
    /// - Parameters:
    ///   - fieldKey: The key for the filter dictionary.
    ///   - fieldValue: The value to be set on the dictionary for the filer key.
    ///   - relation: The relation between the filter key and filter value
    mutating func addFilter(fieldKey: String, fieldValue: String, relation: MetadataFilterBound) {
        let filterObject = FilterStruct(fieldKey: fieldKey, fieldValue: fieldValue, relation: relation)
        filters.append(filterObject)
    }

    private struct CodingKeys: CodingKey {
        var intValue: Int?
        var stringValue: String

        init?(intValue: Int) { self.intValue = intValue; stringValue = "\(intValue)" }
        init?(stringValue: String) { self.stringValue = stringValue }

        static func custom(_ key: String) -> CodingKeys {
            // swiftlint:disable:next force_unwrapping
            return CodingKeys(stringValue: key)!
        }
    }

    /// Encodes the filter struct we constructed.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(templateKey, forKey: .custom("templateKey"))
        try container.encode(scope, forKey: .custom("scope"))
        var filterContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .custom("filters"))
        for filter in filters {
            if filter.relation == MetadataFilterBound.equal {
                try filterContainer.encode(filter.fieldValue, forKey: .custom(filter.fieldKey))
            }
            else if filter.relation == MetadataFilterBound.lessThan {
                var valueContainer = filterContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .custom(filter.fieldKey))
                try valueContainer.encode(filter.fieldValue, forKey: .custom("lt"))
            }
            else if filter.relation == MetadataFilterBound.greaterThan {
                var valueContainer = filterContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .custom(filter.fieldKey))
                try valueContainer.encode(filter.fieldValue, forKey: .custom("gt"))
            }
        }
    }
}

/// Provides functionality for creating a Metadata Search Filter.
public class MetadataSearchFilter {
    var filterArray: [MetadataSearchFilterElement]

    /// Initializer
    public init() {
        filterArray = []
    }

    /// Adds a new filter object to our list of filter objects.
    /// - Parameters:
    ///   - templateKey: The template key for the metadata template.
    ///   - fieldKey: The key to add for the metadata filter field.
    ///   - fieldValue: The value to add for the metadata filter field.
    ///   - scope: The scope of the metadata template.
    ///   - relation: The relation between the field key and field value.
    public func addFilter(
        templateKey: String,
        fieldKey: String,
        fieldValue: String,
        scope: MetadataScope = MetadataScope.enterprise,
        relation: MetadataFilterBound = MetadataFilterBound.equal
    ) {

        if var filterObject = filterArray.first(where: { $0.templateKey == templateKey && $0.scope == scope }) {
            filterObject.addFilter(fieldKey: fieldKey, fieldValue: fieldValue, relation: relation)
        }
        else {
            var filterObject = MetadataSearchFilterElement(templateKey: templateKey, scope: scope)
            filterObject.addFilter(fieldKey: fieldKey, fieldValue: fieldValue, relation: relation)

            filterArray.append(filterObject)
        }
    }
}
