Pod::Spec.new do |s|
  s.name             = "Tailor"
  s.summary          = "A super fast & convenient object mapper tailored for your needs."
  s.version          = "0.2.0"
  s.homepage         = "https://github.com/zenangst/Tailor"
  s.license          = 'MIT'
  s.author           = { "Christoffer Winterkvist" => "christoffer@winterkvist.com" }
  s.source           = { :git => "https://github.com/zenangst/Tailor.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zenangst'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.requires_arc = true
  s.ios.source_files = 'Source/{iOS,Shared}/**/*'
  s.osx.source_files = 'Source/{Mac,Shared}/**/*'

  s.frameworks = 'Foundation'
  s.dependency 'Sugar'
end
