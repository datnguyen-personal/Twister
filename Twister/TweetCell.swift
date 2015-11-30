//
//  TweetCell.swift
//  Twister
//
//  Created by Dat Nguyen on 27/11/15.
//  Copyright © 2015 datnguyen. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
            if tweet.retweet != nil {
                screennameLabel.text = tweet.retweet!.user!.name
                usernameLabel.text = "@\((tweet.retweet!.user!.screenname)!)"
                profileImageView.setImageWithURL(NSURL(string: (tweet.retweet!.user!.profileimageURL)!)!)
                tweetLabel.text = tweet.retweet!.text
            } else {
                screennameLabel.text = tweet.user!.name
                usernameLabel.text = "@\((tweet.user!.screenname)!)"
                profileImageView.setImageWithURL(NSURL(string: (tweet.user?.profileimageURL)!)!)
                tweetLabel.text = tweet.text
            }
            
            createdAtLabel.text = tweet.createAtString
            
            createdAtLabel.text = tweet.timeOffSet
            
            if tweet.isFavorite! {
                favoriteButton.setImage(UIImage(named: "ActiveFavorite"), forState: .Normal)
            } else {
                favoriteButton.setImage(UIImage(named: "FavoriteIcon"), forState: .Normal)
            }
            
            if tweet.isRetweeted! {
                
                retweetButton.setImage(UIImage(named: "ActiveRetweet"), forState: .Normal)
            } else {
                
                retweetButton.setImage(UIImage(named: "RetweetIcon"), forState: .Normal)
            }
            
            if self.tweet.numberOfFavorites != nil {
                self.favoriteLabel.text = String(self.tweet.numberOfFavorites!)
            } else {
                self.favoriteLabel.text = "0"
            }
            
            if self.tweet.numberOfRetweets != nil {
                self.retweetLabel.text = String(self.tweet.numberOfRetweets!)
            } else {
                self.retweetLabel.text = "0"
            }
            
            if tweet.user?.id == User.currentUser?.id {
                retweetButton.enabled = false
            }
        }
    }
    
    @IBAction func onReplyTapped(sender: AnyObject) {
        
    }
    
    @IBAction func onRetweetTapped(sender: AnyObject) {
        if tweet.isRetweeted! {
            
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
                            
                        }
                    })
                }
            })            
            
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
                    
                }
                
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
