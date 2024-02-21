Pod::Spec.new do |s|
  s.name             = 'AppController'
  s.version          = '2.2.0'
  s.summary          = 'A lightweight controller for managing transitions between "unauthenticated" and "authenticated" interfaces on iOS, written in Swift.'
  s.description      = <<-DESC
  The AppController is a lightweight controller for managing transitions 
  between "unauthenticated" and "authenticated" interfaces on iOS. Many apps 
  implement this lazily by presenting an authentication sheet above the main 
  app interface. This is fine for some applications, however if you're looking
  for something more robust, the structure implemented by AppController offers 
  a clean and clear separation of concerns between interfaces for each 
  authentication state. It manages interface transitions using Apple approved 
  view controller containment API, and removes the unused view hierarchy from
  memory once the transition is complete. By keeping your "unauthenticated" 
  and "authenticated" view hierarchies completely separate, you can write cleaner 
  code and build more compelling onboarding experiences.
                       DESC
  s.homepage         = 'https://github.com/cgossain/AppController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Christian Gossain' => 'cgossain@gmail.com' }

  s.source           = { :git => 'https://github.com/cgossain/AppController.git', :tag => s.version.to_s }
  s.source_files     = 'Sources/AppController/**/*'
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
end
