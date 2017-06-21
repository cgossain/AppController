//
// AppViewController.swift
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

open class AppViewController: UIViewController {
    
    /// If `true`, a call to dismiss(animated:completion:) is made before performing the transition. Defaults to `true`.
    var dismissesPresentedViewControllerBeforeTransition = true
    
    /// Returns the view controller that is currently installed.
    open private(set) var installedViewController: UIViewController?
    
    /// Transitions from the currently installed view controller to the specified view controller. If no view controller is installed, then this method simply loads the specified view controller.
    ///
    /// - Parameter toViewController: The view controller to transition to.
    /// - Parameter duration: The duration of the transition animation.
    /// - Parameter options: The transition animation options
    /// - Parameter willBeginTransition: A block that is called just before the transition actually begins (i.e. after internally dismissing a presented view controller, but before the transition)
    /// - Parameter completion: A block to be executed after the transition completes.
    open func transition(to toViewController: UIViewController, duration: TimeInterval, options: UIViewAnimationOptions, willBeginTransition: (() -> Void)? = nil, completion: (() -> Void)?) {
        // prevent adding the view controller if it's already our child
        if toViewController.parent == self {
            return
        }
        
        // this closure defines the entire containment and transtion process
        let transition = {
            willBeginTransition?()
            
            // add the new controller as a child
            self.addChildViewController(toViewController)
            toViewController.view.frame = self.view.bounds
            self.view.addSubview(toViewController.view)
            
            // if there is a view controller currently installed, transition from it to the new one
            // otherwise if no previous view controller was loaded, we can just load the new one
            // immediately (i.e. first loading of a view controller)
            if let fromViewController = self.installedViewController {
                // notify the installed view controller that it is about to be removed
                fromViewController.willMove(toParentViewController: nil)
                
                // update the current reference (needs to be updated for the `setNeedsStatusBarAppearanceUpdate()` call in the animation block)
                self.installedViewController = toViewController
                
                // perform the transition
                self.transition(from: fromViewController, to: toViewController, duration: duration, options: options, animations: {
                    // updating the status bar appearance change within the animation block will animate the status bar color change, if there is one
                    self.setNeedsStatusBarAppearanceUpdate()
                    
                }, completion: { (finished) in
                    // "decontain" the previous child view controller
                    fromViewController.view.removeFromSuperview()
                    fromViewController.removeFromParentViewController()
                    
                    // finish "containing" the new view controller
                    toViewController.didMove(toParentViewController: self)
                    
                    // completion handler
                    completion?()
                })
            }
            else {
                // set the current view controller
                self.installedViewController = toViewController
                
                // update status bar appearance
                self.setNeedsStatusBarAppearanceUpdate()
                
                // simply finish containing the view controller
                toViewController.didMove(toParentViewController: self)
                
                // completion handler
                completion?()
            }
        }
        
        // dismiss anything presented first before transitioning
        if let presented = presentedViewController, dismissesPresentedViewControllerBeforeTransition {
            let animated = (duration > 0)
            presented.dismiss(animated: animated) {
                transition()
            }
        }
        else {
            transition()
        }
    }
    
    open override var childViewControllerForStatusBarStyle : UIViewController? {
        return installedViewController
    }
    
    open override var childViewControllerForStatusBarHidden : UIViewController? {
        return installedViewController
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // resize and animate the installed view controllers' view
        coordinator.animate(alongsideTransition: { (context) in
            let newFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            self.installedViewController?.view.frame = newFrame
        }, completion: nil)
    }
}
