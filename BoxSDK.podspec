Pod::Spec.new do |s|
 s.name = 'BoxSDK'
 s.version = '0.0.1'
 s.license = 'Apache License, Version 2.0'
 s.summary = 'Box Swift SDK'
 s.homepage = 'https://www.box.com'
 s.social_media_url = 'https://twitter.com/box'
 s.authors = { "" => "oss@box.com" }
 s.source = { :git => "git@github.com:box/box-swift-sdk.git", :tag => "v"+s.version.to_s }
 s.platforms = { :ios => "11.0", :osx => "10.12", :tvos => "11.0", :watchos => "3.0" }
 s.requires_arc = true
 s.swift_version = '5.0'
 s.dependency "Alamofire", "~> 5.0.0-beta.6"

 s.default_subspec = "Core"
 s.subspec "Core" do |ss|
     ss.source_files  = "Sources/**/*.swift" , "Sources/**/Environment.plist"
     ss.framework  = "Foundation"
 end
end
