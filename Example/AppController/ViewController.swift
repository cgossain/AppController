//
//  ViewController.swift
//  AppController
//
//  Created by Christian Gossain on 11/17/2015.
//  Copyright (c) 2015 Christian Gossain. All rights reserved.
//

import UIKit
import AppController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var shouldAutorotate: Bool {
        return self.traitCollection.userInterfaceIdiom == .pad
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        AppController.login()
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        AppController.logout()
    }
}
