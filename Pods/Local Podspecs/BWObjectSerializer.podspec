Pod::Spec.new do |s|
  s.name         = "BWObjectSerializer"
  s.version      = "0.1.1"
  s.summary      = "Small library that transform an object into a dictionary that can be send to a web service."
  s.homepage     = "https://github.com/brunow/BWObjectSerializer"
  s.license      = 'Apache License 2.0'
  s.author       = { "Bruno Wernimont" => "hello@brunowernimont.be" }
  s.source       = { :git => "https://github.com/brunow/BWObjectSerializer.git", :tag => "0.1.1" }
  s.platform     = :ios, '5.0'
  s.source_files = 'BWObjectSerializer/*.{h,m}'
  s.requires_arc = true
end