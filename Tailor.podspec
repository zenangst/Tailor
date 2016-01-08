Pod::Spec.new do |s|
  s.name             = "Tailor"
  s.summary          = "A short description of Tailor."
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/zenangst/Tailor"
  s.license          = 'MIT'
  s.author           = { "Christoffer Winterkvist" => "christoffer@winterkvist.com" }
  s.source           = {
    :git => "https://github.com/zenangst/Tailor.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/zenangst'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.requires_arc = true
  s.ios.source_files = 'Sources/{iOS,Shared}/**/*'
  s.osx.source_files = 'Sources/{Mac,Shared}/**/*'

  # s.ios.frameworks = 'UIKit', 'Foundation'
  # s.osx.frameworks = 'Cocoa', 'Foundation'

  # s.dependency 'Whisper', '~> 1.0'
end
