//
//  Collaboration+Extensions.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 15/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

import BoxSDK
import Foundation

extension Collaboration {
    var accessibleByUser: User? {
        if case let .user(user) = accessibleBy?.collaboratorValue {
            return user
        }

        return nil
    }
}
