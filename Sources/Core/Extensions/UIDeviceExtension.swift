//
//  UIDeviceExtension.swift
//  BoxSDK
//
//  Created by Daniel Cech on 09/05/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS)
    import UIKit

    extension UIDevice {

        var modelName: String {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce(into: "") { identifier, element in
                if let value = element.value as? Int8, value != 0 {
                    identifier += String(UnicodeScalar(UInt8(value)))
                }
            }

            switch identifier {

            // list generated from: https://gist.github.com/adamawolf/3048717
            case "i386":
                return "iPhone Simulator"
            case "x86_64":
                return "iPhone Simulator"

            case "iPhone1,1":
                return "iPhone"
            case "iPhone1,2":
                return "iPhone 3G"
            case "iPhone2,1":
                return "iPhone 3GS"
            case "iPhone3,1":
                return "iPhone 4"
            case "iPhone3,2":
                return "iPhone 4 GSM Rev A"
            case "iPhone3,3":
                return "iPhone 4 CDMA"
            case "iPhone4,1":
                return "iPhone 4S"
            case "iPhone5,1":
                return "iPhone 5 (GSM)"
            case "iPhone5,2":
                return "iPhone 5 (GSM+CDMA)"
            case "iPhone5,3":
                return "iPhone 5C (GSM)"
            case "iPhone5,4":
                return "iPhone 5C (Global)"
            case "iPhone6,1":
                return "iPhone 5S (GSM)"
            case "iPhone6,2":
                return "iPhone 5S (Global)"
            case "iPhone7,1":
                return "iPhone 6 Plus"
            case "iPhone7,2":
                return "iPhone 6"
            case "iPhone8,1":
                return "iPhone 6s"
            case "iPhone8,2":
                return "iPhone 6s Plus"
            case "iPhone8,4":
                return "iPhone SE (GSM)"
            case "iPhone9,1":
                return "iPhone 7"
            case "iPhone9,2":
                return "iPhone 7 Plus"
            case "iPhone9,3":
                return "iPhone 7"
            case "iPhone9,4":
                return "iPhone 7 Plus"
            case "iPhone10,1":
                return "iPhone 8"
            case "iPhone10,2":
                return "iPhone 8 Plus"
            case "iPhone10,3":
                return "iPhone X Global"
            case "iPhone10,4":
                return "iPhone 8"
            case "iPhone10,5":
                return "iPhone 8 Plus"
            case "iPhone10,6":
                return "iPhone X GSM"
            case "iPhone11,2":
                return "iPhone XS"
            case "iPhone11,4":
                return "iPhone XS Max"
            case "iPhone11,6":
                return "iPhone XS Max Global"
            case "iPhone11,8":
                return "iPhone XR"
            case "iPhone12,1":
                return "iPhone 11"
            case "iPhone12,3":
                return "iPhone 11 Pro"
            case "iPhone12,5":
                return "iPhone 11 Pro Max"

            case "iPod1,1":
                return "1st Gen iPod"
            case "iPod2,1":
                return "2nd Gen iPod"
            case "iPod3,1":
                return "3rd Gen iPod"
            case "iPod4,1":
                return "4th Gen iPod"
            case "iPod5,1":
                return "5th Gen iPod"
            case "iPod7,1":
                return "6th Gen iPod"
            case "iPod9,1":
                return "7th Gen iPod"

            case "iPad1,1":
                return "iPad"
            case "iPad1,2":
                return "iPad 3G"
            case "iPad2,1":
                return "2nd Gen iPad"
            case "iPad2,2":
                return "2nd Gen iPad GSM"
            case "iPad2,3":
                return "2nd Gen iPad CDMA"
            case "iPad2,4":
                return "2nd Gen iPad New Revision"
            case "iPad3,1":
                return "3rd Gen iPad"
            case "iPad3,2":
                return "3rd Gen iPad CDMA"
            case "iPad3,3":
                return "3rd Gen iPad GSM"
            case "iPad2,5":
                return "iPad mini"
            case "iPad2,6":
                return "iPad mini GSM+LTE"
            case "iPad2,7":
                return "iPad mini CDMA+LTE"
            case "iPad3,4":
                return "4th Gen iPad"
            case "iPad3,5":
                return "4th Gen iPad GSM+LTE"
            case "iPad3,6":
                return "4th Gen iPad CDMA+LTE"
            case "iPad4,1":
                return "iPad Air (WiFi)"
            case "iPad4,2":
                return "iPad Air (GSM+CDMA)"
            case "iPad4,3":
                return "1st Gen iPad Air (China)"
            case "iPad4,4":
                return "iPad mini Retina (WiFi)"
            case "iPad4,5":
                return "iPad mini Retina (GSM+CDMA)"
            case "iPad4,6":
                return "iPad mini Retina (China)"
            case "iPad4,7":
                return "iPad mini 3 (WiFi)"
            case "iPad4,8":
                return "iPad mini 3 (GSM+CDMA)"
            case "iPad4,9":
                return "iPad Mini 3 (China)"
            case "iPad5,1":
                return "iPad mini 4 (WiFi)"
            case "iPad5,2":
                return "4th Gen iPad mini (WiFi+Cellular)"
            case "iPad5,3":
                return "iPad Air 2 (WiFi)"
            case "iPad5,4":
                return "iPad Air 2 (Cellular)"
            case "iPad6,3":
                return "iPad Pro (9.7 inch, WiFi)"
            case "iPad6,4":
                return "iPad Pro (9.7 inch, WiFi+LTE)"
            case "iPad6,7":
                return "iPad Pro (12.9 inch, WiFi)"
            case "iPad6,8":
                return "iPad Pro (12.9 inch, WiFi+LTE)"
            case "iPad6,11":
                return "iPad (2017)"
            case "iPad6,12":
                return "iPad (2017)"
            case "iPad7,1":
                return "iPad Pro 2nd Gen (WiFi)"
            case "iPad7,2":
                return "iPad Pro 2nd Gen (WiFi+Cellular)"
            case "iPad7,3":
                return "iPad Pro 10.5-inch"
            case "iPad7,4":
                return "iPad Pro 10.5-inch"
            case "iPad7,5":
                return "iPad 6th Gen (WiFi)"
            case "iPad7,6":
                return "iPad 6th Gen (WiFi+Cellular)"
            case "iPad7,11":
                return "iPad 7th Gen 10.2-inch (WiFi)"
            case "iPad7,12":
                return "iPad 7th Gen 10.2-inch (WiFi+Cellular)"
            case "iPad8,1":
                return "iPad Pro 3rd Gen (11 inch, WiFi)"
            case "iPad8,2":
                return "iPad Pro 3rd Gen (11 inch, 1TB, WiFi)"
            case "iPad8,3":
                return "iPad Pro 3rd Gen (11 inch, WiFi+Cellular)"
            case "iPad8,4":
                return "iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)"
            case "iPad8,5":
                return "iPad Pro 3rd Gen (12.9 inch, WiFi)"
            case "iPad8,6":
                return "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)"
            case "iPad8,7":
                return "iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)"
            case "iPad8,8":
                return "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)"
            case "iPad11,1":
                return "iPad mini 5th Gen (WiFi)"
            case "iPad11,2":
                return "iPad mini 5th Gen"
            case "iPad11,3":
                return "iPad Air 3rd Gen (WiFi)"
            case "iPad11,4":
                return "iPad Air 3rd Gen"

            case "Watch1,1":
                return "Apple Watch 38mm case"
            case "Watch1,2":
                return "Apple Watch 42mm case"
            case "Watch2,6":
                return "Apple Watch Series 1 38mm case"
            case "Watch2,7":
                return "Apple Watch Series 1 42mm case"
            case "Watch2,3":
                return "Apple Watch Series 2 38mm case"
            case "Watch2,4":
                return "Apple Watch Series 2 42mm case"
            case "Watch3,1":
                return "Apple Watch Series 3 38mm case (GPS+Cellular)"
            case "Watch3,2":
                return "Apple Watch Series 3 42mm case (GPS+Cellular)"
            case "Watch3,3":
                return "Apple Watch Series 3 38mm case (GPS)"
            case "Watch3,4":
                return "Apple Watch Series 3 42mm case (GPS)"
            case "Watch4,1":
                return "Apple Watch Series 4 40mm case (GPS)"
            case "Watch4,2":
                return "Apple Watch Series 4 44mm case (GPS)"
            case "Watch4,3":
                return "Apple Watch Series 4 40mm case (GPS+Cellular)"
            case "Watch4,4":
                return "Apple Watch Series 4 44mm case (GPS+Cellular)"
            case "Watch5,1":
                return "Apple Watch Series 5 40mm case (GPS)"
            case "Watch5,2":
                return "Apple Watch Series 5 44mm case (GPS)"
            case "Watch5,3":
                return "Apple Watch Series 5 40mm case (GPS+Cellular)"
            case "Watch5,4":
                return "Apple Watch Series 5 44mm case (GPS+Cellular)"

            default:
                return identifier
            }
        }
    }
#endif
