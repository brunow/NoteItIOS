Pod::Spec.new do |s|
  s.name         = "BWObjectRouter"
  s.version      = "0.1.0"
  s.summary      = "Small library that generate route with static or dynamic data."
  s.homepage     = "https://github.com/brunow/BWObjectRouter"
  s.license      = 'Apache License 2.0'
  s.author       = { "Bruno Wernimont" => "hello@brunowernimont.be" }
  s.source       = { :git => "https://github.com/brunow/BWObjectRouter.git", :tag => "0.1.0" }
  s.platform     = :ios, '5.0'
  s.source_files = 'BWObjectRouter/*.{h,m}'
  s.requires_arc = true
  s.dependency 'SOCKit', '~> 1.1'
end