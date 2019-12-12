//
//  UsersModule.swift
//  BoxSDK-iOS
//
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Defines user status.
public enum UserStatus: BoxEnum {
    /// User is active
    case active
    /// User is inactive
    case inactive
    /// User cannot delete or edit content
    case cannotDeleteOrEdit
    /// User cannot delete, edit or upload content
    case cannotDeleteEditOrUpload
    /// A custom user status that is not yet implemented
    case customValue(String)

    /// Initializer.
    ///
    /// - Parameter value: String representation of UserStatus.
    public init(_ value: String) {
        switch value {
        case "active":
            self = .active
        case "inactive":
            self = .inactive
        case "cannot_delete_edit":
            self = .cannotDeleteOrEdit
        case "cannot_delete_edit_upload":
            self = .cannotDeleteEditOrUpload
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of user status.
    public var description: String {
        switch self {
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case .cannotDeleteOrEdit:
            return "cannot_delete_edit"
        case .cannotDeleteEditOrUpload:
            return "cannot_delete_edit_upload"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Defines user’s role within an enterprise
public enum UserRole: BoxEnum {
    /// Coadmin role
    case coadmin
    /// Admin role
    case admin
    /// User role
    case user
    /// A custom role that is not yet implemented
    case customValue(String)

    /// Initializer.
    ///
    /// - Parameter value: String representation of UserRole.
    public init(_ value: String) {
        switch value {
        case "coadmin":
            self = .coadmin
        case "admin":
            self = .admin
        case "user":
            self = .user
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of user's role.
    public var description: String {
        switch self {
        case .admin:
            return "admin"
        case .coadmin:
            return "coadmin"
        case .user:
            return "user"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Provides [User](../Structs/User.html) management.
public class UsersModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Get information about the user for which this client is authenticated.
    ///
    /// - Parameters:
    ///   - fields: List of [user object fields](https://developer.box.com/reference#user-object) to
    ///     include in the response.  Only those fields will be populated on the resulting model object.
    ///     If not passed, a default set of fields will be returned.
    ///   - completion: Returns a standard user object or an error.
    public func getCurrent(
        fields: [String]? = nil,
        completion: @escaping Callback<User>
    ) {
        get(userId: BoxSDK.Constants.currentUser, fields: fields, completion: completion)
    }

    /// Get information about a user in the enterprise. Requires enterprise administration
    /// authorization.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///   - fields: List of [user object fields](https://developer.box.com/reference#user-object) to
    ///     include in the response.  Only those fields will be populated on the resulting model object.
    ///     If not passed, a default set of fields will be returned.
    ///   - completion: Returns a standard user object or an error.
    public func get(
        userId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<User>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/users/\(userId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Get image of a user's avatar
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///   - completion: Returns the data object of the avatar image of the user or an error.
    public func getAvatar(
        userId: String,
        completion: @escaping Callback<Data>
    ) {
        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/users/\(userId)/avatar", configuration: boxClient.configuration),
            completion: { (result: Result<BoxResponse, BoxSDKError>) in
                let objectResult: Result<Data, BoxSDKError> = result.flatMap { response in
                    guard let data = response.body else {
                        return .failure(BoxAPIError(message: .notFound("No user avatar returned"), response: response))
                    }
                    return .success(data)
                }
                completion(objectResult)
            }
        )
    }

    /// Create a new managed user in an enterprise. This method only works for Box admins.
    ///
    /// - Parameters:
    ///   - login: The email address the user uses to login
    ///   - name: The name of the user
    ///   - role: The user’s enterprise role. Can be coadmin or user
    ///   - language: The language of the user. Input format follows a modified version of the ISO 639-1 language code format. https://developer.box.com/docs/api-language-codes
    ///   - isSyncEnabled: Whether the user can use Box Sync
    ///   - jobTitle: The user’s job title
    ///   - phone: The user’s phone number
    ///   - address: The user’s address
    ///   - spaceAmount: The user’s total available space amount in bytes
    ///   - trackingCodes: An array of key/value pairs set by the user’s admin
    ///   - canSeeManagedUsers: Whether the user can see other managed users
    ///   - timezone: The user's timezone. Input format follows tz database timezones. https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    ///   - isExternalCollabRestricted: Whether the user is restricted from external collaboration
    ///   - isExemptFromDeviceLimits: Whether to exempt the user from Enterprise device limits
    ///   - isExemptFromLoginVerification: Whether the user must use two-factor authentication
    ///   - status: active, inactive, cannotDeleteOrEdit, or cannotDeleteEditOrupload
    ///   - fields: List of [user object fields](https://developer.box.com/reference#user-object) to
    ///     include in the response.  Only those fields will be populated on the resulting model object.
    ///     If not passed, a default set of fields will be returned.
    ///   - completion: Returns a standard user object or an error.
    public func create(
        login: String,
        name: String,
        role: UserRole? = nil,
        language: String? = nil,
        isSyncEnabled: Bool? = nil,
        jobTitle: String? = nil,
        phone: String? = nil,
        address: String? = nil,
        spaceAmount: Int64? = nil,
        trackingCodes: [User.TrackingCode]? = nil,
        canSeeManagedUsers: Bool? = nil,
        timezone: String? = nil,
        isExternalCollabRestricted: Bool? = nil,
        isExemptFromDeviceLimits: Bool? = nil,
        isExemptFromLoginVerification: Bool? = nil,
        status: UserStatus? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<User>
    ) {
        var body: [String: Any] = ["login": login, "name": name]
        body["role"] = role?.description
        body["language"] = language
        body["is_sync_enabled"] = isSyncEnabled
        body["job_title"] = jobTitle
        body["phone"] = phone
        body["address"] = address
        body["space_amount"] = spaceAmount
        body["tracking_codes"] = trackingCodes
        body["can_see_managed_users"] = canSeeManagedUsers
        body["timezone"] = timezone
        body["is_exempt_from_device_limits"] = isExemptFromDeviceLimits
        body["is_exempt_from_login_verification"] = isExemptFromLoginVerification
        body["is_external_collab_restricted"] = isExternalCollabRestricted
        body["status"] = status?.description

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/users", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Update the information for a user.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///   - login: The ID of the user.
    ///   - name: The name of the user
    ///   - role: The user’s enterprise role. Can be coadmin or user
    ///   - language: The language of the user. Input format follows a modified version of the ISO 639-1 language code format. https://developer.box.com/docs/api-language-codes
    ///   - isSyncEnabled: Whether the user can use Box Sync
    ///   - jobTitle: The user’s job title
    ///   - phone: The user’s phone number
    ///   - address: The user’s address
    ///   - spaceAmount: The user’s total available space amount in bytes
    ///   - trackingCodes: An array of key/value pairs set by the user’s admin
    ///   - canSeeManagedUsers: Whether the user can see other managed users
    ///   - timezone: The user's timezone. Input format follows tz database timezones. https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    ///   - isExternalCollabRestricted: Whether the user is restricted from external collaboration
    ///   - isExemptFromDeviceLimits: Whether to exempt the user from Enterprise device limits
    ///   - isExemptFromLoginVerification: Whether the user must use two-factor authentication
    ///   - status: active, inactive, cannotDeleteOrEdit, or cannotDeleteEditOrupload
    ///   - fields: List of [user object fields](https://developer.box.com/reference#user-object) to
    ///     include in the response.  Only those fields will be populated on the resulting model object.
    ///     If not passed, a default set of fields will be returned.
    ///   - completion: Returns a standard user object or an error.
    public func update(
        userId: String,
        login: String? = nil,
        name: String? = nil,
        role: UserRole? = nil,
        language: String? = nil,
        isSyncEnabled: Bool? = nil,
        jobTitle: String? = nil,
        phone: String? = nil,
        address: String? = nil,
        spaceAmount: Int64? = nil,
        trackingCodes: [User.TrackingCode]? = nil,
        canSeeManagedUsers: Bool? = nil,
        timezone: String? = nil,
        isExternalCollabRestricted: Bool? = nil,
        isExemptFromDeviceLimits: Bool? = nil,
        isExemptFromLoginVerification: Bool? = nil,
        status: UserStatus? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<User>
    ) {

        var body: [String: Any] = [:]
        body["login"] = login
        body["name"] = name
        body["role"] = role?.description
        body["language"] = language
        body["is_sync_enabled"] = isSyncEnabled
        body["job_title"] = jobTitle
        body["phone"] = phone
        body["address"] = address
        body["space_amount"] = spaceAmount
        body["tracking_codes"] = trackingCodes?.compactMap { $0.bodyDict }
        body["can_see_managed_users"] = canSeeManagedUsers
        body["timezone"] = timezone
        body["is_exempt_from_device_limits"] = isExemptFromDeviceLimits
        body["is_exempt_from_login_verification"] = isExemptFromLoginVerification
        body["is_external_collab_restricted"] = isExternalCollabRestricted
        body["status"] = status?.description

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/users/\(userId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Create a new app user in an enterprise.
    ///
    /// - Parameters:
    ///   - name: The name of the user. All special characters are acceptable except for <, >, and " ".
    ///   - language: The language of the user. Input format follows a modified version of the ISO 639-1 language code format. https://developer.box.com/v2.0/docs/api-language-codes
    ///   - jobTitle: The user's job title
    ///   - timezone: The user's timezone. Input format follows tz database timezones. https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    ///   - phone: The user’s phone number
    ///   - address: The user’s address
    ///   - spaceAmount: The user’s total available space amount in bytes
    ///   - status: active, inactive, cannotDeleteOrEdit, or cannotDeleteEditOrupload
    ///   - isExternalCollabRestricted: Whether the user is restricted from external collaboration
    ///   - canSeeManagedUsers: Whether the user can see managed users
    ///   - fields: List of [user object fields](https://developer.box.com/reference#user-object) to
    ///     include in the response.  Only those fields will be populated on the resulting model object.
    ///     If not passed, a default set of fields will be returned.
    ///   - completion: Returns a standard user object or an error.
    public func createAppUser(
        name: String,
        language: String? = nil,
        jobTitle: String? = nil,
        timezone: String? = nil,
        phone: String? = nil,
        address: String? = nil,
        spaceAmount: Int64? = nil,
        status: UserStatus? = nil,
        isExternalCollabRestricted: Bool? = nil,
        canSeeManagedUsers: Bool? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<User>
    ) {

        var body: [String: Any] = [:]
        body["name"] = name
        body["language"] = language
        body["job_title"] = jobTitle
        body["timezone"] = timezone
        body["phone"] = phone
        body["address"] = address
        body["space_amount"] = spaceAmount
        body["status"] = status?.description
        body["is_external_collab_restricted"] = isExternalCollabRestricted
        body["can_see_managed_users"] = canSeeManagedUsers
        body["is_platform_access_only"] = true

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/users", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Delete a user.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user
    ///   - notify: Whether the destination user will receive email notification of the transfer
    ///   - force: Whether the user should be deleted even if this user still own files
    ///   - completion: An empty response will be returned upon successful deletion. An error is
    ///     thrown if the folder is not empty and the ‘recursive’ parameter is not included.
    public func delete(
        userId: String,
        notify: Bool? = nil,
        force: Bool? = nil,
        completion: @escaping Callback<Void>
    ) {

        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/users/\(userId)", configuration: boxClient.configuration),
            queryParameters: ["force": force, "notify": notify],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Returns all of the users for the Enterprise. Only available to admin accounts or service accounts.
    ///
    /// - Parameters:
    ///   - filterTerm: Only return users whose name or login matches the filter_term. See notes below for details on the matching.
    ///   - fields: List of [user object fields](https://developer.box.com/reference#user-object) to
    ///     include in the response.  Only those fields will be populated on the resulting model object.
    ///     If not passed, a default set of fields will be returned.
    ///   - usemarker: This specifies whether you would like to use marker-based or offset-based
    ///     paging. You can only use one or the other. Marker-based paging is the preferred method
    ///     and is most performant. If not specified, this endpoint defaults to using offset-based
    ///     paging. This parameter is unique to Get Folder Items to retain backwards compatibility
    ///     for this endpoint. This parameter is required for both the first and subsequent calls to
    ///     use marked-based paging.
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details. This
    ///     parameter cannot be used simultaneously with the 'offset' parameter.
    ///   - offset: The offset of the item at which to begin the response. See [offset-based paging]
    ///     (https://developer.box.com/reference#section-offset-based-paging) for details.
    ///   - limit: The maximum number of items to return.
    public func listForEnterprise(
        filterTerm: String? = nil,
        fields: [String]? = nil,
        usemarker: Bool? = nil,
        marker: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        completion: @escaping Callback<PagingIterator<User>>
    ) {

        var queryParams: QueryParameters = [
            "filter_term": filterTerm,
            "fields": FieldsQueryParam(fields),
            "limit": limit
        ]

        if usemarker ?? false {
            queryParams["usemarker"] = true
            queryParams["marker"] = marker
        }
        else {
            queryParams["offset"] = offset
        }

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/users", configuration: boxClient.configuration),
            queryParameters: queryParams,
            completion: ResponseHandler.pagingIterator(client: boxClient, wrapping: completion)
        )
    }

    /// Invite an existing user to join an Enterprise.
    ///
    /// - Parameters:
    ///   - enterpriseId: The ID of the enterprise the user will be invited to
    ///   - login: The login of the user that will receive the invitation
    ///   - fields: List of [user object fields](https://developer.box.com/reference#user-object) to
    ///     include in the response.  Only those fields will be populated on the resulting model object.
    ///     If not passed, a default set of fields will be returned.
    ///   - completion: Returns a standard Invite object or an error.
    public func inviteToJoinEnterprise(
        login: String,
        enterpriseId: String,
        fields: [String]? = nil,
        completion: @escaping Callback<Invite>
    ) {

        let body = ["enterprise": ["id": enterpriseId], "actionable_by": ["login": login]]
        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/invites", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Move all of the items owned by a user into a new folder in another user’s account.
    ///
    /// - Parameters:
    ///   - sourceUserID: The ID of the user whose owned content will be moved
    ///   - destinationUserID: The ID of the user who the folder will be transferred to
    ///   - notify: Whether the destination user should receive email notification of the transfer
    ///   - fields: List of [user object fields](https://developer.box.com/reference#user-object) to
    ///     include in the response.  Only those fields will be populated on the resulting model object.
    ///     If not passed, a default set of fields will be returned.
    ///   - completion: Returns a standard Folder object or an error.
    public func moveItemsOwnedByUser(
        withID sourceUserID: String,
        toUserWithID destinationUserID: String,
        notify: Bool? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<Folder>
    ) {

        let body = ["owned_by": ["id": destinationUserID]]

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/users/\(sourceUserID)/folders/0", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields), "notify": notify],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Used to convert one of the user’s confirmed email aliases into the user’s primary login.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user
    ///   - login: The email alias to become the primary email
    ///   - fields: List of [user object fields](https://developer.box.com/reference#user-object) to
    ///     include in the response.  Only those fields will be populated on the resulting model object.
    ///     If not passed, a default set of fields will be returned.
    ///   - completion: Returns a standard User object or an error.
    public func changeLogin(
        userId: String,
        login: String,
        fields: [String]? = nil,
        completion: @escaping Callback<User>
    ) {
        update(userId: userId, login: login, fields: fields, completion: completion)
    }

    /// Retrieves all email aliases for this user.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user
    ///   - completion: Returns a collection of Email Aliases of the user or an error.
    public func listEmailAliases(
        userId: String,
        completion: @escaping Callback<EntryContainer<EmailAlias>>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/users/\(userId)/email_aliases", configuration: boxClient.configuration),

            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Adds a new email alias to the given user’s account.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user
    ///   - email: The email address to add to the account as an alias
    ///   - completion: Returns a  Email Aliases object or an error.
    public func createEmailAlias(
        userId: String,
        email: String,
        completion: @escaping Callback<EmailAlias>
    ) {

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/users/\(userId)/email_aliases", configuration: boxClient.configuration),
            json: ["email": email],
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Removes an email alias from a user.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user
    ///   - emailAliasId: The ID of the email alias
    ///   - completion: An empty response will be returned upon successful deletion. An error is
    ///     thrown if the user don't have permission to delete the email alias.
    public func deleteEmailAlias(
        userId: String,
        emailAliasId: String,
        completion: @escaping Callback<Void>
    ) {

        boxClient.delete(
            url: URL.boxAPIEndpoint("/2.0/users/\(userId)/email_aliases/\(emailAliasId)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Roll a user out of their enterprise (and convert them to a standalone free user)
    ///
    /// - Parameters:
    ///   - userId: The ID of the user
    ///   - notify: Whether the user should receive an email when they are rolled out of an enterprise
    ///   - fields: List of [user object fields](https://developer.box.com/reference#user-object) to
    ///     include in the response.  Only those fields will be populated on the resulting model object.
    ///     If not passed, a default set of fields will be returned.
    ///   - completion: Returns a standard User object of the updated user, or an error.
    public func rollOutOfEnterprise(
        userId: String,
        notify: Bool? = nil,
        fields: [String]? = nil,
        completion: @escaping Callback<User>
    ) {

        var body: [String: Any] = ["enterprise": NSNull()]

        body["notify"] = notify

        boxClient.put(
            url: URL.boxAPIEndpoint("/2.0/users/\(userId)", configuration: boxClient.configuration),
            queryParameters: ["fields": FieldsQueryParam(fields)],
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
