//
//  NewTweetViewController.swift
//  Twister
//
//  Created by Dat Nguyen on 29/11/15.
//  Copyright © 2015 datnguyen. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    func newTweetViewController (newTweetsViewController: NewTweetViewController, didPostTweet tweet: Tweet)
}

class NewTweetViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var tweetTextField: UITextField!
    
    weak var newTweetDelegate: NewTweetViewControllerDelegate?
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = "@\((user.name)!)"
        screennameLabel.text = user.screenname
        profileImageView.setImageWithURL(NSURL(string: user.profileimageURL!)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTweetTapped(sender: AnyObject) {
        let parameters: [String : String] = ["status": tweetTextField.text! as String]
        
        TwisterClient.shareInstance.postATweetWithParams(parameters) { (tweet: Tweet?, error: NSError?) -> () in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            self.newTweetDelegate?.newTweetViewController(
                self, didPostTweet: tweet!)
            
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
