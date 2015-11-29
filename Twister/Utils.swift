//
//  Utils.swift
//  Twister
//
//  Created by Dat Nguyen on 30/11/15.
//  Copyright © 2015 datnguyen. All rights reserved.
//

import UIKit

class Utils: NSObject {
    static func showDialog(title: String, msg: String, vc: UIViewController) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
}
