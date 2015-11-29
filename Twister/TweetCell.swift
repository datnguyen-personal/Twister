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
    
    
    var tweet: Tweet! {
        didSet{
            screennameLabel.text = tweet.user!.name
            usernameLabel.text = "@\((tweet.user!.screenname)!)"
            createdAtLabel.text = tweet.createAtString
            tweetLabel.text = tweet.text
            profileImageView.setImageWithURL(NSURL(string: (tweet.user?.profileimageURL)!)!)
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
