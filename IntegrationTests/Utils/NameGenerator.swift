//
//  NameGenerator.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 01/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

final class NameGenerator {
    private static let prefix = "iOS_SDK"

    static func getUniqueName(for scope: String) -> String {
        return "\(prefix)_\(scope)_\(UUID().uuidString)"
    }

    static func getUniqueFolderName(for scope: String = "test") -> String {
        return "\(prefix)_\(scope)_\(UUID().uuidString)"
    }

    static func getUniqueFileName(withExtension extension: String = "txt") -> String {
        return "\(prefix)_\(UUID().uuidString).\(`extension`)"
    }
}
