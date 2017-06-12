//
// AppController.swift
//
// Copyright (c) 2017 Christian Gossain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

public protocol AppControllerInterfaceProviding {
    /// Return a configuration object.
    func configuration(for appController: AppController) -> AppController.Configuration
    
    /// Return the view controller to be installed as the "logged out" interface.
    func loggedOutInterfaceViewController(for appController: AppController) -> UIViewController
    
    /// Return the view controller to be installed as the "logged in" interface.
    func loggedInInterfaceViewController(for appController: AppController) -> UIViewController
    
    /// Return true if the "logged in" interface should be initially loaded, or false if the "logged out" interface is initially loaded.
    func isInitiallyLoggedIn(for appController: AppController) -> Bool
}

public class AppController {
    
    public struct Configuration {
        /// The animation duration when transitionning between logged in/out states. A duration of zero indicates no animation should occur.
        public let transitionDuration: TimeInterval
        
        /// The transiton animation options.
        public let options: UIViewAnimationOptions
        
        /// If `true`, a call to dismiss(animated:completion:) is made before performing the transition. Defaults to `true`.
        /// - Note: You generally would want this to be `true`, but you have the option to disable it if needed.
        public var dismissesPresentedViewControllerBeforeTransition = true
        
        /// Initializes the configuration with the given options.
        public init(transitionDuration: TimeInterval = 0.6, options: UIViewAnimationOptions = .transitionCrossDissolve) {
            self.transitionDuration = transitionDuration
            self.options = options
        }
    }
    
    /// The object that acts as the interface provider for the controller.
    let interfaceProvider: AppControllerInterfaceProviding
    
    /// A closure that is called just before the transition to the _logged in_ interface begins. The view
    /// controller that is about to be presented is passed to the block as the targetViewController.
    public var willLoginHandler: ((_ targetViewController: UIViewController) -> Void)?
    
    /// A closure that is called after the transition to the _logged in_ interface completes.
    public var didLoginHandler: (() -> Void)?
    
    /// A closure that is called just before the transition to the _logged out_ interface begins. The view
    /// controller that is about to be presented is passed to the block as the targetViewController.
    public var willLogoutHandler: ((_ targetViewController: UIViewController) -> Void)?
    
    /// A closure that is called after the transition to the _logged out_ interface completes.
    public var didLogoutHandler: (() -> Void)?
    
    /// The view controller that should be installed as your window's rootViewController.
    public lazy var rootViewController: AppViewController = {
        if let storyboard = self.storyboard {
            // get the rootViewController from the storyboard
            return storyboard.instantiateInitialViewController() as! AppViewController
        }
        
        // if there is no storyboard, just create an instance of the app view controller (using the custom class if provided)
        return self.appViewControllerClass.init()
    }()
    
    /// Returns the storyboard instance being used if the controller was initialized using the convenience storyboad initializer, otherwise retuns `nil`.
    public var storyboard: UIStoryboard? {
        return (interfaceProvider as? StoryboardInterfaceProvider)?.storyboard
    }
    
    
    // MARK: - Lifecycle
    
    /// Initializes the controller using the specified storyboard name, and uses the given `loggedOutInterfaceID`, and `loggedInInterfaceID` values to instantiate 
    /// the appropriate view controller from the storyboad.
    ///
    /// - Parameter storyboardName: The name of the storyboard that contains the view controllers.
    /// - Parameter loggedOutInterfaceID: The storyboard identifier of the view controller to use as the _logged out_ view controller.
    /// - Parameter loggedInInterfaceID: The storyboard identifier of the view controller to use as the _logged in_ view controller.
    /// - Note: The controller automatically installs the _initial view controller_ from the storyboard as the root view controller. Therfore, the _initial view controller_ in
    ///         the specified storyboard MUST be an instance of `AppViewController`, otherwise a crash will occur.
    ///
    public convenience init(storyboardName: String, loggedOutInterfaceID: String, loggedInInterfaceID: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        self.init(interfaceProvider: StoryboardInterfaceProvider(storyboard: storyboard, loggedOutInterfaceID: loggedOutInterfaceID, loggedInInterfaceID: loggedInInterfaceID))
    }
    
    /// Initializes the controller with closures that return the view controllers to install for the _logged out_ and _logged in_ states.
    /// - Parameter interfaceProvider: The object that will act as the interface provider for the controller.
    /// - Parameter appViewControllerClass: Specify a custom `AppViewController` subclass to use as the rootViewController, or `nil` to use the standard `AppViewController`.
    ///
    public init(interfaceProvider: AppControllerInterfaceProviding, appViewControllerClass: AppViewController.Type? = nil) {
        self.interfaceProvider = interfaceProvider
        
        // replace the default AppViewController class with the custom class, if provided
        if let customAppViewControllerClass =  appViewControllerClass {
            self.appViewControllerClass = customAppViewControllerClass
        }
        
        // observer login notification
        loginNotificationObserver =
            NotificationCenter.default.addObserver(
                forName: AppController.shouldLoginNotification,
                object: nil,
                queue: .main,
                using: { [weak self] notification in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.transitionToLoggedInInterface()
            })
        
        // observe logout notification
        logoutNotificationObserver =
            NotificationCenter.default.addObserver(
                forName: AppController.shouldLogoutNotification,
                object: nil,
                queue: .main,
                using: { [weak self] notification in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.transitionToLoggedOutInterface()
            })
        
        
        // load the desired initial interface without notifying the handlers
        if interfaceProvider.isInitiallyLoggedIn(for: self) {
            transitionToLoggedInInterface(notify: false)
        }
        else {
            transitionToLoggedOutInterface(notify: false)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(loginNotificationObserver!)
        NotificationCenter.default.removeObserver(logoutNotificationObserver!)
    }
    
    // MARK: - Internal References
    
    fileprivate var appViewControllerClass = AppViewController.self
    fileprivate var loginNotificationObserver: AnyObject?
    fileprivate var logoutNotificationObserver: AnyObject?
    
}

extension AppController {
    
    /// Internal notification that is posted on `AppController.login()`.
    fileprivate static let shouldLoginNotification = Notification.Name(rawValue: "AppControllerShouldLoginNotification")
    
    /// Internal notification that is posted on `AppController.logout()`.
    fileprivate static let shouldLogoutNotification = Notification.Name(rawValue: "AppControllerShouldLogoutNotification")
    
    /// Posts a notification that notifies any active AppController instance to switch to its _logged in_ interface.
    /// Note that any given app should only have a single active AppController instance. Therefore that single instance
    /// will be the one that receives and handles the notification.
    public static func login() {
        NotificationCenter.default.post(name: AppController.shouldLoginNotification, object: nil, userInfo: nil)
    }
    
    /// Posts a notification that notifies any active AppController instance to switch to its _logged out_ interface.
    /// Note that any given app should only have a single active AppController instance. Therefore that single instance
    /// will be the one that receives and handles the notification.
    public static func logout() {
        NotificationCenter.default.post(name: AppController.shouldLogoutNotification, object: nil, userInfo: nil)
    }
}

extension AppController {
    
    fileprivate func transitionToLoggedInInterface(notify: Bool = true) {
        let configuration = interfaceProvider.configuration(for: self)
        let target = interfaceProvider.loggedInInterfaceViewController(for: self)
        
        if notify {
            willLoginHandler?(target)
        }
        
        rootViewController.dismissesPresentedViewControllerBeforeTransition = configuration.dismissesPresentedViewControllerBeforeTransition
        rootViewController.transition(to: target, duration: configuration.transitionDuration, options: configuration.options) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            if notify {
                strongSelf.didLoginHandler?()
            }
        }
    }
    
    fileprivate func transitionToLoggedOutInterface(notify: Bool = true) {
        let configuration = interfaceProvider.configuration(for: self)
        let target = interfaceProvider.loggedOutInterfaceViewController(for: self)
        
        if notify {
            willLogoutHandler?(target)
        }
        
        rootViewController.dismissesPresentedViewControllerBeforeTransition = configuration.dismissesPresentedViewControllerBeforeTransition
        rootViewController.transition(to: target, duration: configuration.transitionDuration, options: configuration.options) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            if notify {
                strongSelf.didLogoutHandler?()
            }
        }
    }
    
}
