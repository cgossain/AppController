Pod::Spec.new do |s|
  s.name             = 'AppController'
  s.version          = '0.7.0'
  s.summary          = 'A simple controller that manages transitioning between "signed out" and "signed in" interfaces in iOS, written in Swift.'
  s.description      = <<-DESC
                       Modern iOS applications typically have the need to sign in. Many apps implement this lazily by presenting a login view controller above the main app interface. This project offers a cleaner alternative with a controller that can manage transitioning to/from the required interfaces. This approach means that the interface that is no longer being used can be completely deallocated from memory.
                       DESC
  s.homepage         = 'https://github.com/cgossain/AppController'
  s.license          = 'MIT'
  s.author           = { 'Christian Gossain' => 'cgossain@gmail.com' }
  s.source           = { :git => 'https://github.com/cgossain/AppController.git', :tag => s.version.to_s }
  s.platform         = :ios, '10.3'
  s.swift_version = '5.0'
  s.source_files = 'Pod/Classes/**/*.swift'
end
