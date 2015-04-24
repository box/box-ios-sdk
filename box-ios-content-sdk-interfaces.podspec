Pod::Spec.new do |s|


# Root specification

s.name                  = "box-ios-content-sdk-interfaces"
s.version               = "1.0.2"
s.summary               = "iOS SDK for the Box V2 API."
s.homepage              = "https://github.com/box/box-ios-content-sdk"
s.license               = { :type => "Apache 2.0", :file => "LICENSE" }
s.author                = "Box"
s.source                = { :git => "https://github.com/box/box-ios-content-sdk.git", :tag => "v#{s.version}" }

# Platform

s.ios.deployment_target = "7.0"

# File patterns


s.ios.source_files        = "BoxContentSDK/BoxContentSDK/*.{h}", "BoxContentSDK/BoxContentSDK/**/*.{h}"
s.ios.exclude_files       = "BoxContentSDK/BoxContentSDK/External/ISO8601DateFormatter/BOXISO8601DateFormatter.{h,m}",
"BoxContentSDK/BoxContentSDK/External/KeychainItemWrapper/BOXKeychainItemWrapper.{h,m}"
s.ios.public_header_files = "BoxContentSDK/BoxContentSDK/*.h", "BoxContentSDK/BoxContentSDK/**/*.h"

# Build settings

s.ios.frameworks        = "Security", "QuartzCore", "AssetsLibrary"
s.requires_arc          = true
s.xcconfig              = { "OTHER_LDFLAGS" => "-ObjC -all_load" }
s.ios.header_dir        = "BoxContentSDK"
end
