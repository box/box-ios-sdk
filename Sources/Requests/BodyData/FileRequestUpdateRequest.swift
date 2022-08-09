//
//  FileRequestUpdateRequest.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 09/08/2022.
//  Copyright © Box. All rights reserved.
//

import Foundation

// The request body to update a file request.
public struct FileRequestUpdateRequest: Encodable {

    // MARK: - Properties

    /// An optional new title for the file request.
    /// This can be used to change the title of the file request.
    public let title: String?
    /// An optional new description for the file request.
    /// This can be used to change the description of the file request.
    public let description: String?
    /// An optional new status of the file request.
    public let status: FileRequestStatus?
    /// Whether a file request submitter is required to provide their email address.
    /// When this setting is set to true, the Box UI will show an email field on the file request form.
    public let isEmailRequired: Bool?
    /// Whether a file request submitter is required to provide a description of the files they are submitting.
    /// When this setting is set to true, the Box UI will show a description field on the file request form.
    public let isDescriptionRequired: Bool?
    /// The date after which a file request will no longer accept new submissions.
    /// After this date, the `status` will automatically be set to `inactive`.
    public let expiresAt: Date?

    /// Initializer.
    ///
    /// - Parameters:
    ///   - title: An optional new title for the file request.
    ///   - description: An optional new description for the file request.
    ///   - status: An optional new status of the file request.
    ///   - isEmailRequired: Whether a file request submitter is required to provide their email address.
    ///   - isDescriptionRequired: Whether a file request submitter is required to provide a description of the files they are submitting.
    ///   - expiresAt: The date after which a file request will no longer accept new submissions.
    public init(
        title: String? = nil,
        description: String? = nil,
        status: FileRequestStatus? = nil,
        isEmailRequired: Bool? = nil,
        isDescriptionRequired: Bool? = nil,
        expiresAt: Date? = nil
    ) {
        self.title = title
        self.description = description
        self.status = status
        self.isEmailRequired = isEmailRequired
        self.isDescriptionRequired = isDescriptionRequired
        self.expiresAt = expiresAt
    }
}
