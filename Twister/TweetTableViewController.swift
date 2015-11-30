//
//  TweetTableViewController.swift
//  Twister
//
//  Created by Dat Nguyen on 29/11/15.
//  Copyright © 2015 datnguyen. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol TweetTableViewDelegate {
    func tweetTableViewController(tweetTableViewController: TweetTableViewController, didUpdateATweet tweet: Tweet, row:Int)
}

class TweetTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var detailCell: UITableViewCell!
    @IBOutlet weak var extraCell: UITableViewCell!
    @IBOutlet weak var actionCell: UITableViewCell!
    
    var tweet: Tweet!
    
    var row: Int!
    
    weak var tweetDelegate: TweetTableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if tweet.user?.id == User.currentUser?.id {
            retweetButton.enabled = false
        }
        
        nameLabel.text = tweet.user?.name
        screennameLabel.text = "@\((tweet.user?.screenname)!)"
        tweetLabel.text = tweet.text
        createdAtLabel.text = tweet.createAtString
        profileImageView.setImageWithURL(NSURL(string: (tweet.user?.profileimageURL)!)!)
        
        if tweet.numberOfRetweets != nil {
            retweetLabel.text = String(tweet.numberOfRetweets!)
        } else {
            retweetLabel.text = "0"
        }
        
        if tweet.numberOfFavorites != nil {
            favoriteLabel.text = String(tweet.numberOfFavorites!)
        } else {
            favoriteLabel.text = "0"
        }
        
        if tweet.isRetweeted! {
            retweetButton.setImage(UIImage(named: "ActiveRetweet"), forState: .Normal)
        } else {
            retweetButton.setImage(UIImage(named: "RetweetIcon"), forState: .Normal)
        }
        
        if tweet.isFavorite! {
            favoriteButton.setImage(UIImage(named: "ActiveFavorite"), forState: .Normal)
        } else {
            favoriteButton.setImage(UIImage(named: "FavoriteIcon"), forState: .Normal)
        }
        
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
        
        let backgroundView = UIView(frame: CGRectZero)
        tableView.tableFooterView = backgroundView
        
        //tableView.backgroundColor = UIColor.clearColor()
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            return detailCell
        } else if indexPath.row == 1 {
            return extraCell
        } else if indexPath.row == 2 {
            return actionCell
        }

        return UITableViewCell()
    }
    
    @IBAction func onReplyTapped(sender: AnyObject) {
        
        
    }
    
    @IBAction func onRetweetTapped(sender: AnyObject) {
        
        if tweet.isRetweeted! {
            
            let UndoRetweetAlert = UIAlertController(title: "Undi Retweet", message: "Undo Retweet?.", preferredStyle: UIAlertControllerStyle.Alert)
            
            UndoRetweetAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                var id: String!
                
                if self.tweet.retweet != nil {
                    id = self.tweet.retweet?.id
                } else {
                    id = self.tweet.id
                }
                
                TwisterClient.shareInstance.getRetweetWithID(id, completion: { (tweet, error) -> () in
                    if tweet != nil && tweet?.currentUserRetweetID != nil {
                        TwisterClient.shareInstance.removeARetweetWithID((tweet?.currentUserRetweetID!)!, completion: { (result, error) -> () in
                            if result != nil {
                                self.tweet.isRetweeted = false
                                self.tweet.numberOfRetweets = self.tweet.numberOfRetweets! - 1
                                
                                if self.tweet.numberOfRetweets != nil {
                                    self.retweetLabel.text = String(self.tweet.numberOfRetweets!)
                                } else {
                                    self.retweetLabel.text = "0"
                                }
                                
                                self.retweetButton.setImage(UIImage(named: "RetweetIcon"), forState: .Normal)
                                
                                self.tweetDelegate?.tweetTableViewController(self, didUpdateATweet: self.tweet, row: self.row)
                            }
                        })
                    }
                })
            }))
            
            UndoRetweetAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                UndoRetweetAlert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            presentViewController(UndoRetweetAlert, animated: true, completion: nil)
            
            
        } else {
            TwisterClient.shareInstance.postARetweet(tweet.id!) { (result, error) -> () in
                if result != nil {
                    self.tweet.isRetweeted = true
                    self.tweet.numberOfRetweets = self.tweet.numberOfRetweets! + 1
                    
                    if self.tweet.numberOfRetweets != nil {
                        self.retweetLabel.text = String(self.tweet.numberOfRetweets!)
                    } else {
                        self.retweetLabel.text = "0"
                    }
                    
                    self.retweetButton.setImage(UIImage(named: "ActiveRetweet"), forState: .Normal)
                    
                    self.tweetDelegate?.tweetTableViewController(self, didUpdateATweet: self.tweet, row: self.row)
                }
            }
        }
        
    }
    
    @IBAction func onFavoriteTapped(sender: AnyObject) {
        let parameters: [String : String] = ["id": tweet.id!]
        
        if tweet.isFavorite! {
            TwisterClient.shareInstance.removeFavoriteWithParams(parameters, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.tweet.isFavorite = false
                    self.tweet.numberOfFavorites = self.tweet.numberOfFavorites! - 1
                    
                    if self.tweet.numberOfFavorites != nil {
                        self.favoriteLabel.text = String(self.tweet.numberOfFavorites!)
                    } else {
                        self.favoriteLabel.text = "0"
                    }
                    
                    self.favoriteButton.setImage(UIImage(named: "FavoriteIcon"), forState: .Normal)
                    
                    self.tweetDelegate?.tweetTableViewController(self, didUpdateATweet: self.tweet, row: self.row)
                }
            })
            
        } else {
            
            TwisterClient.shareInstance.postFavoriteWithParams(parameters, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.tweet.isFavorite = true
                    self.tweet.numberOfFavorites = self.tweet.numberOfFavorites! + 1
                    
                    if self.tweet.numberOfFavorites != nil {
                        self.favoriteLabel.text = String(self.tweet.numberOfFavorites!)
                    } else {
                        self.favoriteLabel.text = "0"
                    }
                    
                    self.favoriteButton.setImage(UIImage(named: "ActiveFavorite"), forState: .Normal)
                    
                    self.tweetDelegate?.tweetTableViewController(self, didUpdateATweet: self.tweet, row: self.row)
                }
                
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let newTweetNavigationController = segue.destinationViewController as! UINavigationController
        
        let newTweetViewController = newTweetNavigationController.topViewController as! NewTweetViewController
        
        newTweetViewController.tweet = tweet
    }
    

}
