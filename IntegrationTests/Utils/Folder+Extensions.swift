//
//  Folder+Extensions.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 03/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

import BoxSDK
import Foundation

extension Folder {
    static func generateUniqueName() -> String {
        return NameGenerator.generateUniqueName(for: "Folder")
    }
}
