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
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
    weak var newTweetDelegate: NewTweetViewControllerDelegate?
    
    var user: User!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        user = User.currentUser
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
        let tweetText = tweetTextField.text! as String
        
        if tweetText == "" {
            Utils.showDialog("Error", msg: "Please add tweet", vc: self)
            return
        }
        
        var parameters: [String : String] = ["status": tweetText]
        
        if tweet != nil {
            parameters["in_reply_to_status_id"] = tweet?.id
        }
        
        TwisterClient.shareInstance.postATweetWithParams(parameters) { (tweet: Tweet?, error: NSError?) -> () in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            self.newTweetDelegate?.newTweetViewController(
                self, didPostTweet: tweet!)
            
        }
    }
    
    @IBAction func onTweetTextChanged(sender: AnyObject) {
        let tweetText = tweetTextField.text! as String
        
        let count = 140 - tweetText.characters.count
        
        countLabel.text = String(count)
        
        if count < 0 {
            tweetButton.enabled = false
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
