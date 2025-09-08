//
//  UIColorExtension.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 5/4/20.
//  Copyright © 2020 box. All rights reserved.
//

#if canImport(UIKit)
    import UIKit

    /// The color type used natively on the target platform.
    public typealias PlatformColor = UIColor
#elseif canImport(AppKit)
    import AppKit

    /// The color type used natively on the target platform.
    public typealias PlatformColor = NSColor
#else
    /// A representation of a color using red, green, blue, and alpha components.
    ///
    /// This class is designed to be platform-independent, providing a simple way to store
    /// and transfer color information in a normalized (0.0 - 1.0) format.
    public class PlatformColor {

        /// The red component of the color (0.0 - 1.0).
        public let red: Double

        /// The green component of the color (0.0 - 1.0).
        public let green: Double

        /// The blue component of the color (0.0 - 1.0).
        public let blue: Double

        /// The alpha (opacity) component of the color (0.0 - 1.0).
        public let alpha: Double

        /// Initializes a new `PlatformColor` with specified RGBA components.
        ///
        /// - Parameters:
        ///   - red: The red component (0.0 - 1.0).
        ///   - green: The green component (0.0 - 1.0).
        ///   - blue: The blue component (0.0 - 1.0).
        ///   - alpha: The alpha (opacity) component (0.0 - 1.0).
        public init(red: Double, green: Double, blue: Double, alpha: Double) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
    }
#endif

extension PlatformColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        guard hexSanitized.count == 6 || hexSanitized.count == 8 else {
            return nil
        }

        guard let hexNumber = UInt64(hexSanitized, radix: 16) else {
            return nil
        }

        let red, green, blue, alpha: Double
        if hexSanitized.count == 8 {
            red = Double((hexNumber & 0xFF00_0000) >> 24) / 255.0
            green = Double((hexNumber & 0x00FF_0000) >> 16) / 255.0
            blue = Double((hexNumber & 0x0000_FF00) >> 8) / 255.0
            alpha = Double(hexNumber & 0x0000_00FF) / 255.0
        }
        else {
            red = Double((hexNumber & 0xFF0000) >> 16) / 255.0
            green = Double((hexNumber & 0x00FF00) >> 8) / 255.0
            blue = Double(hexNumber & 0x0000FF) / 255.0
            alpha = 1.0
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
