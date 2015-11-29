//
//  User.swift
//  Twister
//
//  Created by Dat Nguyen on 26/11/15.
//  Copyright © 2015 datnguyen. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileimageURL: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        self.name = dictionary["name"] as? String
        self.screenname = dictionary["screen_name"] as? String
        self.profileimageURL = dictionary["profile_image_url_https"] as? String
        self.tagline = dictionary["description"] as? String
    }
    
    func doLogOut(){
        User.currentUser = nil
        TwisterClient.shareInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
        
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                let data = try! NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: .PrettyPrinted)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
}
