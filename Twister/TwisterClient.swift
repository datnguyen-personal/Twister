//
//  TwisterClient.swift
//  Twister
//
//  Created by Dat Nguyen on 26/11/15.
//  Copyright © 2015 datnguyen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let consumerKey = "CIvEHOtwcryH6gUljmfJu7TK7"
let consumerSecret = "v4181hIU23SYk7LtRxGMI71V7v48aXiWFWJjvCFKf5HCZB1VN1"
let twisterBaseURL = NSURL(string: "https://api.twitter.com")

class TwisterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var shareInstance: TwisterClient {
        struct Static {
            static let instance = TwisterClient(baseURL: twisterBaseURL, consumerKey: consumerKey, consumerSecret: consumerSecret)
            
        }
        return Static.instance
    }
    
    func postARetweet(id: String, completion:(result :Tweet?, error: NSError?) -> ()){
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(result: tweet, error: nil)
            
        }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            
            print("Failed to post retweet")
            completion(result: nil, error: error)
            
        }
    }
    
    func removeARetweetWithID(id: String, completion:(result :Tweet?, error: NSError?) -> ()){
        POST("1.1/statuses/destroy/\(id).json", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(result: tweet, error: nil)
            
            }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                
                print("Failed to remove retweet")
                completion(result: nil, error: error)
                
        }
    }
    
    func getRetweetWithID(id: String, completion:(tweet :Tweet?, error: NSError?) -> ()) {
        GET("https://api.twitter.com/1.1/statuses/show/\(id).json?include_my_retweet=1", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("Failed to get home timeline")
                completion(tweet: nil, error: error)
        })
    }
    
    func postFavoriteWithParams(params: NSDictionary?, completion:(tweet:Tweet?, error: NSError?) -> ()){
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("Failed to add a favorite")
                completion(tweet: nil, error: error)
        }
    }
    
    func removeFavoriteWithParams(params: NSDictionary?, completion:(tweet:Tweet?, error: NSError?) -> ()){
        POST("1.1/favorites/destroy.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("Failed to remove a favorite")
                completion(tweet: nil, error: error)
        }
    }
    
    func postATweetWithParams(params: NSDictionary?, completion:(tweet:Tweet?, error: NSError?) -> ()){
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }) { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            print("Failed to post new tweet")
            completion(tweet: nil, error: error)
        }
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            let tweets = Tweet.tweetsWithArray((response as! [NSDictionary]))
            completion(tweets: tweets, error: nil)
        
        }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
            print("Failed to get home timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginCompletion = completion
        
        //Fetch my request token & redirect to authorization page
        TwisterClient.shareInstance.requestSerializer.removeAccessToken()
        TwisterClient.shareInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwister://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                print("Failed to get the request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        TwisterClient.shareInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token", accessToken)
            TwisterClient.shareInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwisterClient.shareInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
                
                let user = User(dictionary: response as! NSDictionary)
                let name = (user.name)! as String
                
                print("user", name)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
                
                }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                    print("Failed to get user")
                    self.loginCompletion?(user: nil, error: error)
                    
            })
            
            
            }) { (error: NSError!) -> Void in
                print("Failed to get access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }

}
