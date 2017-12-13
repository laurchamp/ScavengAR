//
//  FBLoginControllerViewController.swift
//  ScavengAR
//
//  Created by Lauren Champeau on 11/27/17.
//  Copyright © 2017 Lauren Champeau. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FBLoginControllerViewController: UIViewController {
    var loginButton : FBSDKLoginButton!
    let readPermissions = ["public_profile", "email", "user_friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let manager: FBSDKLoginManager = FBSDKLoginManager()
        // force login screen to open in web view (avoid simulator error when app not installed)
        manager.loginBehavior = FBSDKLoginBehavior.web
        
        // if logged in, segue to next screen
        if (FBSDKAccessToken.current() != nil){
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        } else { // if not, log in with specified read permissions, etc
            manager.logIn(withReadPermissions: self.readPermissions, from: self, handler: { (result, error) in
                // if there is an error or the user cancelled the login, log out
                if (error != nil) || (result?.isCancelled)!{
                    manager.logOut()
                } else { // otherwise, get the current access token for later, dismiss the login screen, and segue to the next screen
                    let currentAccessToken = FBSDKAccessToken.current()
                    self.dismiss(animated: false, completion: nil)
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            })
        }
    }
}
