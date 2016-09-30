
Pod::Spec.new do |s|

  s.name         = "box-ios-sdk-tests"
  s.version      = "1.0.14"
  s.summary      = "A common testing interface extracted from Content SDK."
  s.license      = { :type => "Apache 2.0", :file => "LICENSE" }
  s.author       = "Box"
  s.homepage     = "https://github.com/box/box-ios-sdk"
  s.source       = { :git => "https://github.com/box/box-ios-sdk.git", :tag => "v#{s.version}" }
  
  # Platform

  s.ios.deployment_target = "7.0"

  # File patterns

  s.source_files = "BoxContentSDK/BoxContentSDKTests/BOXCannedResponse.{h,m}", 
  "BoxContentSDK/BoxContentSDKTests/BOXCannedURLProtocol.{h,m}",
  "BoxContentSDK/BoxContentSDKTests/BOXInputStreamTestHelper.{h,m}",
  "BoxContentSDK/BoxContentSDKTests/BOXModelTestCase.{h,m}",
  "BoxContentSDK/BoxContentSDKTests/BOXContentSDKTestCase.{h,m}",
  "BoxContentSDK/BoxContentSDKTests/BOXRequestTestCase.{h,m}",
  "BoxContentSDK/BoxContentSDKTests/ALAssetRepresentationMock.{h,m}"
  s.resources    = "BoxContentSDK/BoxContentSDKTests/*.json"

  # Build settings

  s.requires_arc = true
  s.framework    = "XCTest"
  s.dependency 'OCMock', '~> 3.1.2'
  s.dependency 'box-ios-sdk'

end
