//
//  Tweet.swift
//  Twister
//
//  Created by Dat Nguyen on 26/11/15.
//  Copyright © 2015 datnguyen. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createAtString: String?
    var createAt: NSDate?
    var timeOffSet: String?
    var numberOfRetweets: Int?
    var numberOfFavorites: Int?
    var isRetweeted: Bool?
    var isFavorite: Bool?
    var id: String?
    
    var retweet: Tweet?
    
    var currentUserRetweetID: String?
    
    var inReplyToUserID: String?
    
    init(dictionary: NSDictionary) {
        self.user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        self.text = dictionary["text"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        
        let formatterShort = NSDateFormatter()
        formatterShort.dateFormat = "dd/M/yy, HH:mm"
        
        let timezoneAbbreviation = NSTimeZone.localTimeZone().abbreviation
        formatter.timeZone = NSTimeZone(abbreviation: timezoneAbbreviation!)
        self.createAt = formatter.dateFromString((dictionary["created_at"] as? String)!)
        
        self.createAtString = formatterShort.stringFromDate(createAt!)
        
        self.timeOffSet = self.createAt?.offsetToNow(formatter)
        
        self.numberOfRetweets = dictionary["retweet_count"] as? Int
        self.numberOfFavorites = dictionary["favorite_count"] as? Int
        
        self.isFavorite = dictionary["favorited"] as? Bool
        self.isRetweeted = dictionary["retweeted"] as? Bool
        
        self.id = dictionary["id_str"] as? String
        
        if dictionary["retweeted_status"] != nil {
            self.retweet = Tweet(dictionary: dictionary["retweeted_status"] as! NSDictionary)
        } else {
            self.retweet = nil
        }
        
        if dictionary["in_reply_to_screen_name"] != nil {
            self.inReplyToUserID = dictionary["in_reply_to_screen_name"] as? String
        } else {
            self.inReplyToUserID = nil
        }
        
        if dictionary["current_user_retweet"] != nil {
            let currentUserRetweet = dictionary["current_user_retweet"] as! NSDictionary
            self.currentUserRetweetID = currentUserRetweet["id_str"] as? String
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for tweet: NSDictionary in array {
            tweets.append(Tweet(dictionary: tweet))
        }
        
        return tweets
    }
    
    
}

extension NSDate {
    
    func offsetToNow(formatter: NSDateFormatter) -> String {
        let calendar = NSCalendar.currentCalendar()
        
        let units: NSCalendarUnit = [.WeekOfYear, .Day, .Hour, .Minute, .Second]
        let components = calendar.components(units, fromDate: self, toDate: NSDate(), options: [])
        
        var timeOffSet: String = ""
        
        if components.weekOfYear > 0 {
            timeOffSet = formatter.stringFromDate(self)
        } else if components.day > 0 {
            timeOffSet = String(components.day) + "d"
        } else if components.hour > 0 {
            timeOffSet = String(components.hour) + "h"
        } else if components.minute > 0 {
            timeOffSet = String(components.minute) + "m"
        } else if components.second > 0 {
            timeOffSet = String(components.second) + "s"
        } else {
            timeOffSet = "Now"
        }
        
        return timeOffSet
    }
    
}
