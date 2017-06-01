Pod::Spec.new do |s|
  s.name             = 'AppController'
  s.version          = '0.5.1'
  s.summary          = 'A simple controller to manage switching between `logged out` and `logged in` interfaces in iOS apps, written in Swift.'
  s.description      = <<-DESC
                       Modern iOS applications typically have the ability to login. Many apps implement this lazily by presenting a login view controller above the main app interface. This project offers a cleaner alternative with a controller that can manage transitioning to/from the required interface. This approach means that the interface that is no longer being used can be completely deallocated from memory.
                       DESC
  s.homepage         = 'https://github.com/cgossain/AppController'
  s.license          = 'MIT'
  s.author           = { 'Christian Gossain' => 'cgossain@gmail.com' }
  s.source           = { :git => 'https://github.com/cgossain/AppController.git', :tag => s.version.to_s }
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*.swift'
end
