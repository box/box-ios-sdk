//
//  Task+Extensions.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 15/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

import BoxSDK
import Foundation

extension Task {
    var fileItem: File? {
        if case let .file(file) = item {
            return file
        }

        return nil
    }
}
