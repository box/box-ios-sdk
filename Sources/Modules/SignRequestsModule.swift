//
//  SignRequestsModule.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 08/10/2021.
//  Copyright © 2021 box. All rights reserved.
//
import Foundation

/// Provides management of Sign Requests
public class SignRequestsModule {
    /// Required for communicating with Box APIs.
    weak var boxClient: BoxClient!
    // swiftlint:disable:previous implicitly_unwrapped_optional

    /// Initializer
    ///
    /// - Parameter boxClient: Required for communicating with Box APIs.
    init(boxClient: BoxClient) {
        self.boxClient = boxClient
    }

    /// Creates a sign request. This involves preparing a document for signing and sending the sign request to signers.
    ///
    /// - Parameters:
    ///   - signers: List of signers for the sign request. 35 is the max number of signers permitted.
    ///   - sourceFiles: List of files to create a signing document from. This is currently limited to ten files.
    ///   - parentFolder: The destination folder to place final, signed document and signing log.
    ///     The root folder, folder ID `0`, cannot be used.
    ///   - parameters: The optional parameters.
    ///   - completion: Returns a SignRequest response object if successful otherwise a BoxSDKError.
    public func create(
        signers: [SignRequestCreateSigner],
        sourceFiles: [SignRequestCreateSourceFile],
        parentFolder: SignRequestCreateParentFolder,
        parameters: SignRequestCreateParameters? = nil,
        completion: @escaping Callback<SignRequest>
    ) {
        var body: [String: Any] = [:]
        body["signers"] = signers.map { $0.bodyDict }
        body["source_files"] = sourceFiles.map { $0.bodyDict }
        body["parent_folder"] = parentFolder.bodyDict

        if let unwrappedParameters = parameters {
            for (key, value) in unwrappedParameters.bodyDict {
                body[key] = value
            }
        }

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/sign_requests", configuration: boxClient.configuration),
            json: body,
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// List all sign requests.
    ///
    /// - Parameters:
    ///   - marker: The position marker at which to begin the response. See [marker-based paging]
    ///     (https://developer.box.com/reference#section-marker-based-paging) for details.
    ///   - limit: The maximum number of items to return.
    /// - Returns: Returns a pagination iterator to fetch SignRequest items.
    public func list(
        marker: String? = nil,
        limit: Int? = nil
    ) -> PagingIterator<SignRequest> {
        .init(
            client: boxClient,
            url: URL.boxAPIEndpoint("/2.0/sign_requests", configuration: boxClient.configuration),
            queryParameters: [
                "marker": marker,
                "limit": limit
            ]
        )
    }

    /// Get  sign request by ID.
    ///
    /// - Parameters:
    ///   - id: The ID of the sign request.
    ///   - completion: Returns a SignRequest response object if successful otherwise a BoxSDKError.
    public func getById(
        id: String,
        completion: @escaping Callback<SignRequest>
    ) {

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/sign_requests/\(id)", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Resends a sign request email to all outstanding signers.
    /// There is a 10 minute cooling-off period between each resend request.
    /// If you make a resend call during the cooling-off period, a BoxAPIError will be thrown.
    ///
    /// - Parameters:
    ///   - id: The ID of the sign request.
    ///   - completion: Returns an empty response if successful otherwise a BoxSDKError.
    public func resendById(
        id: String,
        completion: @escaping Callback<Void>
    ) {

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/sign_requests/\(id)/resend", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Cancels a sign request if it has not yet been signed or declined.
    /// Any outstanding signers will no longer be able to sign the document.
    ///
    /// - Parameters:
    ///   - id: The ID of the sign request.
    ///   - completion: Returns a cancelled SignRequest response object if successful otherwise a BoxSDKError.
    public func cancelById(
        id: String,
        completion: @escaping Callback<SignRequest>
    ) {

        boxClient.post(
            url: URL.boxAPIEndpoint("/2.0/sign_requests/\(id)/cancel", configuration: boxClient.configuration),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
