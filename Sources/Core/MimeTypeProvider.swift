//
//  MimeTypeProvider.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 08/07/2022.
//  Copyright © 2022 box. All rights reserved.
//

import Foundation

#if canImport(UniformTypeIdentifiers)
    import UniformTypeIdentifiers
#endif

#if canImport(MobileCoreServices)
    import MobileCoreServices
#endif

/// Provides method for converting given filename to mime type
enum MimeTypeProvider {

    /// Converting given filename to mime type
    ///
    /// - Parameters:
    ///   - filename: A file name with extension (e.g. image.png)
    /// - Returns: A mime type
    static func getMimeTypeFrom(filename: String) -> String {
        let defaultMimeType = "application/octet-stream"
        let url = NSURL(fileURLWithPath: filename)

        guard let pathExtension = url.pathExtension else {
            return defaultMimeType
        }

        if #available(iOS 14, macOS 11.0, watchOS 7.0, tvOS 14.0, *) {
            return UTType(filenameExtension: pathExtension)?.preferredMIMEType ?? defaultMimeType
        }
        else {
            if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue(),
               let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimeType as String
            }
        }

        return defaultMimeType
    }
}
