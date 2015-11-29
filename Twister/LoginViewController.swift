//
//  LoginViewController.swift
//  Twister
//
//  Created by Dat Nguyen on 24/11/15.
//  Copyright © 2015 datnguyen. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginTapped(sender: AnyObject) {
        TwisterClient.shareInstance.loginWithCompletion { (user, error) -> () in
            if user != nil {
                //perform segue to navigate to home timeline
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                //login failed
                
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
