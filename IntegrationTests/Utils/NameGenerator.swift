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

    static func generateUniqueName(for item: String) -> String {
        return "\(prefix)_\(item)_\(UUID().uuidString)"
    }
}
