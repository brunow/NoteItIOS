Pod::Spec.new do |s|
  s.name         = "FormKit.m"
  s.version      = "0.1.0"
  s.summary      = "FormKit.m is a library that helps building form with table view."
  s.homepage     = "https://github.com/brunow/FormKit.m"
  s.license      = 'Apache License 2.0'
  s.author       = { "Bruno Wernimont" => "hello@brunowernimont.be" }
  s.source       = { :git => "https://github.com/brunow/FormKit.m.git", :tag => "0.1.1" }
  s.platform     = :ios, '5.0'
  s.source_files = 'FormKit/*.{h,m}', 'FormKit/Fields/*.{h,m}'
  s.requires_arc = true
  s.dependency 'BWLongTextViewController'
  s.dependency 'ActionSheetPicker2'
  s.dependency 'BWSelectViewController', :git => "https://github.com/brunow/BWSelectViewController.git", :tag => "0.1.1"
end