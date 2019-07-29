Pod::Spec.new do |s|
  s.name             = 'AppController'
  s.version          = '0.7.2'
  s.summary          = 'A simple controller that manages transitions between "logged out" and "logged in" interfaces for iOS apps, written in Swift.'
  s.description      = <<-DESC
                       Modern iOS applications typically have the need to authenticate their users. This typically involves transitionning between a login/signup page and the actual app interface.
                       
                       Many apps implement this lazily by presenting a login view controller above the main app interface. This project offers a cleaner and simple alternative via a controller that can properly manage these transitions for you by using proper view controller containment. This approach has many benefits (e.g cleaner and more logical structure, the unused interface can be completely deallocated from memory when not in use, etc).
                       DESC
  s.homepage         = 'https://github.com/cgossain/AppController'
  s.license          = 'MIT'
  s.author           = { 'Christian Gossain' => 'cgossain@gmail.com' }
  s.source           = { :git => 'https://github.com/cgossain/AppController.git', :tag => s.version.to_s }
  s.platform         = :ios, '10.3'
  s.swift_version = '5.0'
  s.source_files = 'AppController/Classes/**/*.swift'
end
