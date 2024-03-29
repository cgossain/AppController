//
//  StoryboardInterfaceProvider.swift
//
//  Copyright (c) 2021 Christian Gossain
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

final class StoryboardInterfaceProvider: AppControllerInterfaceProviding {
    let storyboard: UIStoryboard
    let loggedOutInterfaceID: String
    let loggedInInterfaceID: String
    let configuration: AppController.Configuration
    
    // MARK: - Init
    
    init(
        storyboard: UIStoryboard,
        loggedOutInterfaceID: String,
        loggedInInterfaceID: String,
        configuration: AppController.Configuration
    ) {
        self.storyboard = storyboard
        self.loggedOutInterfaceID = loggedOutInterfaceID
        self.loggedInInterfaceID = loggedInInterfaceID
        self.configuration = configuration
    }
    
    // MARK: - AppControllerInterfaceProviding
    
    func configuration(for appController: AppController, traitCollection: UITraitCollection) -> AppController.Configuration {
        configuration
    }
    
    func loggedOutInterfaceViewController(for appController: AppController) -> UIViewController {
        storyboard.instantiateViewController(withIdentifier: loggedOutInterfaceID)
    }
    
    func loggedInInterfaceViewController(for appController: AppController) -> UIViewController {
        storyboard.instantiateViewController(withIdentifier: loggedInInterfaceID)
    }
    
    func isInitiallyLoggedIn(for appController: AppController) -> Bool {
        false
    }
}
