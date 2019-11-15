//
//  TermsOfServicesModule.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 8/14/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

/// Specifies whether the Terms of Service is currently active or inactive.
public enum TermsOfServiceStatus: BoxEnum {
    /// The ToS is currently enabled and active.
    case enabled
    /// The ToS is currently disabled and inactive.
    case disabled
    /// Custom value for enum values not yet implemented in the SDK
    case customValue(String)

    /// Initializer.
    ///
    /// - Parameter value: String representation of active/inactive indicator flag for ToS.
    public init(_ value: String) {
        switch value {
        case "enabled":
            self = .enabled
        case "disabled":
            self = .disabled
        default:
            self = .customValue(value)
        }
    }

    /// String representation of active/inactive indicator for ToS.
    public var description: String {
        switch self {
        case .enabled:
            return "enabled"
        case .disabled:
            return "disabled"
        case let .customValue(value):
            return value
        }
    }
}

/// Specifies whether the ToS is managed by an enterprise or external to an enterprise.
public enum TermsOfServiceType: BoxEnum {
    /// The ToS is allowed to be accepted/rejected by managed users.
    case managed
    /// The ToS is allowed to be accepted/rejected by external users.
    case external
    /// Custom value for enum values not yet implemented in the SDK
    case customValue(String)

    /// Initializer.
    ///
    /// - Parameter value: String representation of managed/external indicator flag for ToS.
    public init(_ value: String) {
        switch value {
        case "managed":
            self = .managed
        case "external":
            self = .external
        default:
            self = .customValue(value)
        }
    }

    /// String representation of scope of the ToS to the end users.
    public var description: String {
        switch self {
        case .managed:
            return "managed"
        case .external:
            return "external"
        case let .customValue(value):
            return value
        }
    }
}

/// Provides [TermsOfService](../Structs/TermsOfService.html) management.
public class TermsOfServicesModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Creates a Terms of Service for an enterprise.
    ///
    /// - Parameters:
    ///   - status: The flag for whether a Terms of Service is active or inactive.
    ///   - tosType: The scope of the terms of service whether or not it is internal or external to an enterprise.
    ///   - text: The text of the Terms of Service to be displayed to the user.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full Terms of Service object or an error.
    public func create(
        status: TermsOfServiceStatus,
        tosType: TermsOfServiceType,
        text: String,
        fields: [String]? = nil,
        completion: @escaping Callback<TermsOfService>
    ) {
        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/terms_of_services", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: [
                "status": status.description,
                "tos_type": tosType.description,
                "text": text
            ],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Updates a specified Terms of Service.
    ///
    /// - Parameters:
    ///   - tosId: The id of the Terms of Service to update.
    ///   - text: The text of the Terms of Service to be updated.
    ///   - status: The flag for whether a Terms of Service is active or inactive to be updated.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full Terms of Service object or an error.
    public func update(
        tosId: String,
        text: String,
        status: TermsOfServiceStatus,
        fields: [String]? = nil,
        completion: @escaping Callback<TermsOfService>
    ) {
        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/terms_of_services/\(tosId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: [
                "text": text,
                "status": status.description
            ],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Retrieves a specified Terms of Service.
    ///
    /// - Parameters:
    ///   - tosId: The id of the Terms of Service to retrieve information for.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a full Terms of Service object or an error.
    public func get(
        tosId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<TermsOfService>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/terms_of_services/\(tosId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Retrieves both external and managed Terms of Services if no Terms of Service type is specified.
    ///
    /// - Parameters:
    ///   - tosType: Optional field indicating whether to retrieve managed, external, or both types of Terms of Service. If left `nil`, both types will be returned.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a collection of Terms of Service object or an error.
    public func listForEnterprise(
        tosType: TermsOfServiceType? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<[TermsOfService]>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/terms_of_services", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields), "tos_type": tosType?.description],
            completion: { result in
                completion(result.flatMap {
                    ObjectDeserializer.deserialize(data: $0.body).flatMap { (container: EntryContainer<TermsOfService>) in
                        Result.success(container.entries)
                    }
                })
            }
        )
    }

    /// Creates an association between a terms of service and a specified user. If no user is specified, defaults to current user.
    ///
    /// - Parameters:
    ///   - tosId: The id of the terms of service to associate with a user.
    ///   - isAccepted: Indicator whether or not the Terms of Service has been accepted by the user.
    ///   - userId: The user to create association with terms of service on. If no user id is specified, defaults to current user.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a Terms of Service User Status object or an error.
    public func createUserStatus(
        tosId: String,
        isAccepted: Bool,
        userId: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<TermsOfServiceUserStatus>
    ) {
        var body: [String: Any] = [
            "tos": [
                "type": "terms_of_service",
                "id": tosId
            ],
            "is_accepted": isAccepted
        ]

        if let userId = userId {
            body["user"] = [
                "type": "user",
                "id": userId
            ]
        }
        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/terms_of_service_user_statuses", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Update the user status on the Terms of Service. Choose to either accept or deny.
    ///
    /// - Parameters:
    ///   - userStatusId: The id of the user status to act on.
    ///   - isAccepted: Indicates whether or not the Terms of Service is accepted or denied by the user.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a Terms of Service User Status object or an error.
    public func updateUserStatus(
        userStatusId: String,
        isAccepted: Bool,
        fields: [String]? = nil,
        completion: @escaping Callback<TermsOfServiceUserStatus>
    ) {
        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/terms_of_service_user_statuses/\(userStatusId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: [
                "is_accepted": isAccepted
            ],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Retrieves the user status for the specified Terms of Service and the specified user.
    ///
    /// - Parameters:
    ///   - tosId: The id of the Terms of Service to retrieve the user status for.
    ///   - userId: The optional id of the user to retrieve the user status for.
    ///   - fields: Comma-separated list of [fields](https://developer.box.com/reference#fields) to
    ///     include in the response.
    ///   - completion: Returns a collection of Terms of Service User Status object or an error.
    public func getUserStatus(
        tosId: String,
        userId: String? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<TermsOfServiceUserStatus>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/terms_of_service_user_statuses", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields), "tos_id": tosId, "user_id": userId],
            completion: ResponseHandler.unwrapCollection(wrapping: completion)
        )
    }
}
