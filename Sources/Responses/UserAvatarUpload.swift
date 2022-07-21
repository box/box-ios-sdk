//
//  UserAvatarUpload.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 07/07/2022.
//  Copyright © 2022 box. All rights reserved.
//

import Foundation

/// Box representation of a upload avatar response
public class UserAvatarUpload: BoxModel {

    /// A resource holding URLs to the avatar uploaded to a Box application.
    public struct PicUrls: BoxInnerModel {
        /// URL with the preview representation of avatar
        public let preview: String
        /// URL with the small representation of avatar
        public let small: String
        /// URL with the large representation of avatar
        public let large: String
    }

    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let picUrls: PicUrls

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        picUrls = try BoxJSONDecoder.decode(json: json, forKey: "pic_urls")
    }
}
