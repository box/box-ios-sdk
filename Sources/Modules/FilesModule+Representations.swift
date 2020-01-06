//
//  FilesModule+Representations.swift
//  BoxSDK
//
//  Created by Daniel Cech on 01/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Extension of FilesModule that handles file representations
public extension FilesModule {

    /// Get representations for a file.
    ///
    /// - Parameters:
    ///   - fileId: The id of the file to retrieve representations for.
    ///   - representationHint: The representation to retrieve for the file. It can be one of predefined
    ///     options or custom representation, see [representation
    ///     documentation](https://developer.box.com/reference#representations).
    ///   - completion: Returns an array of the specified representations.
    func listRepresentations(
        fileId: String,
        representationHint: FileRepresentationHint? = nil,
        completion: @escaping Callback<[FileRepresentation]>
    ) {
        var headers: [String: String] = [:]

        if let xRepHints = representationHint?.description {
            headers["x-rep-hints"] = xRepHints
        }

        boxClient.get(
            url: URL.boxAPIEndpoint("/2.0/files/\(fileId)", configuration: boxClient.configuration),
            httpHeaders: headers,
            queryParameters: ["fields": FieldsQueryParam(["representations"])],
            completion: { result in
                let objectResult: Result<File, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }
                switch objectResult {
                case let .success(file):
                    guard let entries = file.representations?.entries else {
                        return completion(.failure(BoxAPIError(message: .notFound("File does not have any representations"))))
                    }
                    completion(.success(entries))
                case let .failure(error):
                    return completion(.failure(error))
                }
            }
        )
    }

    /// Get particular representation for a file.
    ///
    /// - Parameters:
    ///   - fileId: The id of the file to retrieve representations for.
    ///   - representationHint: The representation to retrieve for the file. It can be one of predefined
    ///     options or custom representation. If multiple representations match the representationHint,
    ///     the behavior is undefined - used representation is selected nondeterministically.
    ///     See [representation documentation](https://developer.box.com/reference#representations).
    ///   - assetPath: Asset path for representations with multiple files
    ///   - destinationURL: A URL for the location on device that we want to store the file once been donwloaded
    ///   - completion: Returns an array of the specified representations.
    func getRepresentationContent(
        fileId: String,
        representationHint: FileRepresentationHint,
        assetPath: String = "",
        destinationURL: URL,
        progress: @escaping (Progress) -> Void = { _ in },
        completion: @escaping Callback<Void>
    ) {
        listRepresentations(fileId: fileId, representationHint: representationHint) { [weak self] result in
            guard let self = self else {
                completion(.failure(BoxSDKError(message: .instanceDeallocated("Unable to get representation content - FilesModule deallocated"))))
                return
            }

            switch result {
            case let .success(representations):
                guard let firstRepresentation = representations.first else {
                    completion(.failure(BoxAPIError(message: .notFound("File does not have representations"))))
                    return
                }

                self.processRepresentation(firstRepresentation, assetPath: assetPath) { result in
                    switch result {
                    case let .success(url):
                        self.downloadRepresentation(sourceURL: url, destinationURL: destinationURL, progress: progress, completion: completion)

                    case .failure:
                        completion(.failure(BoxAPIError(message: .representationCreationFailed)))
                    }
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension FilesModule {

    func processRepresentation(
        _ representation: FileRepresentation,
        assetPath: String = "",
        completion: @escaping Callback<URL>
    ) {
        guard
            let status = representation.status?.state,
            let assetString = representation.content?.urlTemplate?.replacingOccurrences(of: "{+asset_path}", with: assetPath),
            let assetURL = URL(string: assetString),
            let infoURLString = representation.info?.url,
            let infoURL = URL(string: infoURLString)
        else {
            completion(.failure(BoxAPIError(message: .representationCreationFailed)))
            return
        }

        switch status {
        case .none, .pending:
            pollRepresentation(infoURL: infoURL, assetPath: assetPath, completion: completion)

        case .success, .viewable:
            completion(.success(assetURL))

        case .error:
            completion(.failure(BoxAPIError(message: .representationCreationFailed)))

        default:
            completion(.failure(BoxAPIError(message: .representationCreationFailed)))
        }
    }

    func pollRepresentation(
        infoURL: URL,
        assetPath: String = "",
        completion: @escaping Callback<URL>
    ) {
        boxClient.get(url: infoURL) { result in
            switch result {
            case let .success(response):
                guard let bodyData = response.body else {
                    completion(.failure(BoxAPIError(message: .representationCreationFailed, response: response)))
                    return
                }

                // swiftlint:disable:next force_unwrapping
                let responseJsonData = bodyData.isEmpty ? "{}".data(using: .utf8)! : bodyData
                let responseJSON = try? JSONSerialization.jsonObject(with: responseJsonData, options: []) as? [String: Any]
                guard
                    let statusDict = responseJSON?["status"] as? [String: Any],
                    let stateString = statusDict["state"] as? String,
                    let contentDict = responseJSON?["content"] as? [String: Any],
                    let contentURLString = contentDict["url_template"] as? String,
                    let contentURL = URL(string: contentURLString.replacingOccurrences(of: "{+asset_path}", with: assetPath))
                else {
                    completion(.failure(BoxAPIError(message: .representationCreationFailed, response: response)))
                    return
                }

                let state = FileRepresentation.StatusEnum(stateString)

                switch state {
                case .none, .pending:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                        guard let self = self else {
                            completion(.failure(BoxSDKError(message: .instanceDeallocated("Unable to poll for representations - FilesModule deallocated"))))
                            return
                        }

                        self.pollRepresentation(infoURL: infoURL, completion: completion)
                    }

                case .viewable, .success:
                    completion(.success(contentURL))

                case .error:
                    completion(.failure(BoxAPIError(message: .representationCreationFailed)))

                default:
                    completion(.failure(BoxAPIError(message: .representationCreationFailed)))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Download a file to a specified folder.
    ///
    /// - Parameters:
    ///   - fileId: The ID of the file
    ///   - destinationURL: A URL for the location on device that we want to store the file once been donwloaded
    ///   - version: Optional file version ID to download (defaults to the current version)
    ///   - completion: Returns an empty response or an error
    public func downloadRepresentation(
        sourceURL: URL,
        destinationURL: URL,
        progress: @escaping (Progress) -> Void = { _ in },
        completion: @escaping Callback<Void>
    ) {

        boxClient.download(
            url: sourceURL,
            downloadDestinationURL: destinationURL,
            progress: progress,
            completion: { result in
                completion(result.map { _ in })
            }
        )
    }
}
