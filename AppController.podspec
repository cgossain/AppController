Pod::Spec.new do |s|
  s.name             = "AppController"
  s.version          = "0.4.0"
  s.summary          = "A clean and simple way to transition between a login interface and a main interface in iOS apps."
  s.description      = <<-DESC
                       Many iOS applications need to implement login functionality. This project aims to provide a clean and simple architecture for doing this. The AppController is object that manages the login and main interfaces of your application.
                       DESC
  s.homepage         = "https://github.com/cgossain/AppController"
  s.license          = 'MIT'
  s.author           = { "Christian Gossain" => "cgossain@gmail.com" }
  s.source           = { :git => "https://github.com/cgossain/AppController.git", :tag => s.version.to_s }
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*.swift'
end
