//
//  Watermark.swift
//  BoxSDK
//
//  Created by Albert Wu on 8/26/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Watermark object labels folders and files to be protected by watermarks, which will show on file previews.
/// Watermarks can be applied to folders and files independently.
public class Watermark: BoxModel {

    public private(set) var rawData: [String: Any]
    public static let resourceKey: String = "watermark"

    public static let imprintKey: String = "imprint"
    public static let defaultImprint: String = "default"

    // MARK: - Properties

    /// The time this watermark was created.
    public let createdAt: Date?
    /// The time this watermark was last modified.
    public let modifiedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
    }

    /// WatermarkResponse represents the direct response from the watermarking
    /// endpoints which are watermark objects wrapped in a top level
    /// watermark: { } key
    class WatermarkResponse: BoxModel {
        private(set) var rawData: [String: Any]

        /// The unwrapped watermark object
        let watermark: Watermark

        /// Initializer.
        ///
        /// - Parameter json: JSON dictionary.
        /// - Throws: Decoding error.
        required init(json: [String: Any]) throws {
            guard let unwrappedWatermark: Watermark = try BoxJSONDecoder.optionalDecode(json: json, forKey: Watermark.resourceKey) else {
                throw BoxCodingError(message: .typeMismatch(key: Watermark.resourceKey))
            }

            rawData = json
            watermark = unwrappedWatermark
        }
    }

    /// Transforms a WatermarkResponse result into a result with the
    /// unwrapped watermark object.
    ///
    /// - Parameter result: WatermarkResponse result
    static func unwrapWatermarkObject(from result: Result<WatermarkResponse, BoxSDKError>) -> Result<Watermark, BoxSDKError> {
        switch result {
        case let .success(response):
            return .success(response.watermark)
        case let .failure(error):
            return .failure(error)
        }
    }
}
