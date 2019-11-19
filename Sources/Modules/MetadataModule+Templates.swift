//
//  MetadataModule+Templates.swift
//  BoxSDK
//
//  Created by Daniel Cech on 28/06/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Defines methods for [MetadataTemplate](../Structs/MetadataTemplate.html) management
public extension MetadataModule {

    /// Get metadata template by name (templateKey).
    ///
    /// - Parameters:
    ///   - scope: The scope of metadata template - possible values are "global" or "enterprise_{id}"
    ///   - templateKey: A unique identifier for the template.
    ///   - completion: Returns a metadata template info or an error if the scope or templateKey are invalid or
    ///     the user doesn't have access to the template.
    func getTemplateByKey(
        scope: String,
        templateKey: String,
        completion: @escaping Callback<MetadataTemplate>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/metadata_templates/\(scope)/\(templateKey)/schema", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get metadata template by ID.
    ///
    /// - Parameters:
    ///   - id: The identifier of template
    ///   - completion: Returns a metadata template info or an error if ID is invalid or
    ///     the user doesn't have access to the template.
    func getTemplateById(
        id: String,
        completion: @escaping Callback<MetadataTemplate>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/metadata_templates/\(id)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Create metadata template.
    ///
    /// - Parameters:
    ///   - scope: The scope of the object. Only the enterprise scope is supported.
    ///   - templateKey: A unique identifier for the template.
    ///   - displayName: The display name of the template.
    ///   - hidden: Whether this template is hidden in the UI. Defaults to false.
    ///   - fields: Definition of fields for this metadata template.
    ///   - completion: Returns success or an error if template is invalid or
    ///     the user doesn't have access to the file.
    func createTemplate(
        scope: String,
        templateKey: String,
        displayName: String,
        hidden: Bool,
        fields: [MetadataField],
        completion: @escaping Callback<MetadataTemplate>
    ) {
        var json: [String: Any] = [
            "templateKey": templateKey,
            "scope": scope,
            "displayName": displayName,
            "hidden": hidden
        ]

        json["fields"] = fields.map { $0.bodyDictWithDefaultKeys }

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/metadata_templates/schema", configuration: boxClient.configuration),
            json: json,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Update metadata template.
    ///
    /// - Parameters:
    ///   - scope: The scope of the object. Only the enterprise scope is supported.
    ///   - templateKey: A unique identifier for the template.
    ///   - operation: Description of operation on template. See [template update operations]
    ///     (https://developer.box.com/reference#update-metadata-schema).
    ///   - completion: Returns success or an error if template is invalid or
    ///     the user doesn't have access to the file.
    func updateTemplate(
        scope: String,
        templateKey: String,
        operation: MetadataTemplateOperation,
        completion: @escaping Callback<MetadataTemplate>
    ) {
        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/metadata_templates/\(scope)/\(templateKey)/schema", configuration: boxClient.configuration),
            json: operation.json(),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Delete metadata template.
    ///
    /// - Parameters:
    ///   - scope: The scope of the object.
    ///   - templateKey: Metadata template object
    ///   - completion: Returns success or an error if template is invalid or
    ///     the user doesn't have access to the file.
    func deleteTemplate(
        scope: String,
        templateKey: String,
        completion: @escaping Callback<Void>
    ) {
        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/metadata_templates/\(scope)/\(templateKey)/schema", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Retrieve all metadata templates within the specified enterprise
    ///
    /// - Parameters:
    ///   - scope: The scope of the object. Only the enterprise scope is supported.
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details.
    ///   - limit: The maximum number of items to return. The default is 100 and the maximum is
    ///     1,000.
    func listEnterpriseTemplates(
        scope: String,
        marker: String? = nil,
        limit: Int? = nil,
        completion: @escaping Callback<PagingIterator<MetadataTemplate>>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/metadata_templates/\(scope)", configuration: boxClient.configuration),
            queryParameters: [
                "marker": marker,
                "limit": limit
            ],
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }
}
