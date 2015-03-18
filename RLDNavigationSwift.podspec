Pod::Spec.new do |s|
  s.name         = 'RLDNavigationSwift'
  s.version      = '0.4.0'
  s.homepage     = 'https://github.com/rlopezdiez/RLDNavigationSwift.git'
  s.summary      = 'Framework to decouple navigation from view controllers, written in Swift'
  s.authors      = { 'Rafael Lopez Diez' => 'https://www.linkedin.com/in/rafalopezdiez' }
  s.source       = { :git => 'https://github.com/rlopezdiez/RLDNavigationSwift.git', :tag => s.version.to_s }
  s.source_files = 'Classes/*.swift'
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
end
