//
//  Date+Extensions.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 03/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

import BoxSDK
import Foundation

extension Date {
    static var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }

    static func addDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: Date())!
    }
}
