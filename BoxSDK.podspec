Pod::Spec.new do |spec|
  spec.name         = "BoxSDK"
  spec.version      = "4.0.0"
  spec.summary      = "Box Swift SDK"
  spec.description  = <<-DESC
  Official Box Swift SDK.
                   DESC
  spec.homepage     = "https://github.com/box/box-ios-sdk"
  spec.license      = "Apache License, Version 2.0"
  spec.author             = { "Box" => "sdks@box.com" }
  spec.social_media_url   = "https://twitter.com/box"
  spec.ios.deployment_target = "11.0"
  spec.source       = { :git => "https://github.com/box/box-ios-sdk.git", :tag => "v"+spec.version.to_s }
  spec.swift_versions = ["5.0", "5.1"]
  spec.requires_arc = true

  spec.default_subspec = "Core"
  spec.subspec "Core" do |ss|
      ss.source_files  = "Sources/**/*.swift" , "Sources/**/Environment.plist"
      # spec.exclude_files = "Sources/Exclude"
      ss.framework  = "Foundation"
  end
end
