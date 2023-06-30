//
//  TestAssets.swift
//  BoxSDK
//
//  Created by James Lawton on 6/19/23.
//  Copyright © 2023 Box. All rights reserved.
//

import Foundation

#if canImport(UIKit)
    import UIKit
#endif

final class TestAssets {

    static let resourceBundle: Bundle = {
        Bundle(for: TestAssets.self)
    }()

    static func url(forResource name: String) -> URL? {
        resourceBundle.url(forResource: name, withExtension: nil)
    }

    static func path(forResource name: String) -> String? {
        resourceBundle.path(forResource: name, ofType: nil)
    }

    #if canImport(UIKit)
        static func image(named: String) -> UIImage? {
            UIImage(named: named, in: resourceBundle, compatibleWith: nil)
        }
    #endif
}
