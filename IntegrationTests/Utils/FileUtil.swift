//
//  FileUtil.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 17/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

class FileUtil {
    static func getFileContent(fileName: String) -> Data? {
        if let content = NSData(contentsOfFile: getFilePath(fileName: fileName)) {
            return content as Data
        }

        return nil
    }

    static func getFilePath(fileName: String) -> String {
        let resourceName = URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent
        let resourceExtension = URL(fileURLWithPath: fileName).pathExtension
        return Bundle(for: FileUtil.self).path(forResource: resourceName, ofType: resourceExtension)!
    }

    static func getDestinationUrl(for fileName: String) -> URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent(fileName)
    }
}
