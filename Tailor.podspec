Pod::Spec.new do |s|
  s.name             = "Tailor"
  s.summary          = "A super fast & convenient object mapper tailored for your needs."
  s.version          = "0.2.0"
  s.homepage         = "https://github.com/zenangst/Tailor"
  s.license          = 'MIT'
  s.author           = { "Christoffer Winterkvist" => "christoffer@winterkvist.com" }
  s.source           = { :git => "https://github.com/zenangst/Tailor.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zenangst'
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Source/**/*'

  s.dependency 'Sugar'
end
