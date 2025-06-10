Pod::Spec.new do |spec|
  spec.name         = "BoxSDK"
  spec.version      = "5.6.0"
  spec.summary      = "Box Swift SDK"
  spec.description  = <<-DESC
  Official Box Swift SDK.
                   DESC
  spec.homepage     = "https://github.com/box/box-ios-sdk"
  spec.license      = "Apache License, Version 2.0"
  spec.author             = { "Box" => "sdks@box.com" }
  spec.social_media_url   = "https://twitter.com/box"
  spec.osx.deployment_target = '10.15'
  spec.ios.deployment_target = '13.0'
  spec.tvos.deployment_target = '13.0'
  spec.watchos.deployment_target = '6.0'
  spec.visionos.deployment_target = '1.0'
  spec.source       = { :git => "https://github.com/box/box-ios-sdk.git", :tag => spec.version.to_s }
  spec.swift_versions = ["5"]
  spec.requires_arc = true

  spec.default_subspec = "Core"
  spec.subspec "Core" do |ss|
      ss.source_files  = "BoxSDK/Sources/**/*.swift" , "BoxSDK/Sources/**/Environment.plist"
      ss.resource_bundle = {"BoxSDK" => "BoxSDK/Sources/PrivacyInfo.xcprivacy"}
      ss.framework  = "Foundation"
  end
end
