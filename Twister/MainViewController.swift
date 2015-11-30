//
//  MainViewController.swift
//  Twister
//
//  Created by Dat Nguyen on 24/11/15.
//  Copyright © 2015 datnguyen. All rights reserved.
//

import UIKit
import KVNProgress

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewTweetViewControllerDelegate, TweetTableViewDelegate {

    @IBOutlet weak var tweetTableView: UITableView!
    
    var tweets: [Tweet]?
    
    var refreshControl: UIRefreshControl!
    
    var isInitiatingData: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fetchTweets(true)
        
        setupRefreshControl()
        
        setupNavigationBar()
        
        //NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "onRefreshTweets", userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tweetTableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetCell
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets!.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tweetTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func fetchTweets(withLoading: Bool) {
        if withLoading {
            KVNProgress.showWithStatus("Twisting...")
            isInitiatingData = true
        }
        
        TwisterClient.shareInstance.homeTimelineWithParams(nil, completion: {(tweets: [Tweet]?, error: NSError?)->() in
            
            if tweets != nil {
                self.tweets = tweets!
            } else {
                self.tweets = [Tweet]()
                
            }
            
            self.tweetTableView.delegate = self
            self.tweetTableView.dataSource = self
            
            self.tweetTableView.estimatedRowHeight = 200
            self.tweetTableView.rowHeight = UITableViewAutomaticDimension
            
            self.tweetTableView.reloadData()
            
            self.refreshControl.endRefreshing()
            
            KVNProgress.dismiss()
            
            self.isInitiatingData = false
        })
    }
    
    func setupRefreshControl(){
        refreshControl = UIRefreshControl()
        //refreshControl.tintColor = UIColor.clearColor()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tweetTableView.addSubview(refreshControl)
        
    }
    
    func setupNavigationBar() {
        let logoImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, 25, 21))
        logoImage.image = UIImage(named: "BlueBirdIcon")
        logoImage.contentMode = .ScaleAspectFit
        self.navigationItem.titleView = logoImage
    }
    
    func onRefresh(){
        fetchTweets(false)
    }
    
    @IBAction func onLogOutTapped(sender: AnyObject) {
        let logoutAlert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?.", preferredStyle: UIAlertControllerStyle.Alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Log out", style: .Default, handler: { (action: UIAlertAction!) in
            User.currentUser?.doLogOut()
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            logoutAlert.dismissViewControllerAnimated(true, completion: nil)
            self.tweetTableView.reloadData()
        }))
        
        presentViewController(logoutAlert, animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tweetTableView.indexPathForCell(cell)!
        
        switch segue.identifier! {
        case "detailSegue":
            
            
            let tweetViewController = segue.destinationViewController as! TweetTableViewController
            
            tweetViewController.tweet = tweets![indexPath.row]
            tweetViewController.row = indexPath.row
            tweetViewController.tweetDelegate = self
            break
            
        case "newTweetSegue":
            let newTweetNavigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = newTweetNavigationController.topViewController as! NewTweetViewController
            
            newTweetViewController.newTweetDelegate = self
            break
            
        case "replyTweetSegue":
            let newTweetNavigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = newTweetNavigationController.topViewController as! NewTweetViewController
            
            newTweetViewController.newTweetDelegate = self
            newTweetViewController.tweet = tweets![indexPath.row]
            break
            
        default: break
        }
        
    }
    
    func newTweetViewController(newTweetsViewController: NewTweetViewController, didPostTweet tweet: Tweet) {
        self.tweets! = addNewTweet(self.tweets!, newTweet: tweet)
        tweetTableView.reloadData()
    }
    
    func tweetTableViewController(tweetTableViewController: TweetTableViewController, didUpdateATweet tweet: Tweet, row: Int) {
        
        tweets![row] = tweet
        tweetTableView.reloadData()
    }
    
    func addNewTweet(tweets: [Tweet], newTweet: Tweet) -> [Tweet] {
        var newTweets: [Tweet] = [Tweet]()
        newTweets.append(newTweet)
        
        for tw in tweets {
            newTweets.append(tw)
        }
        
        return newTweets
    }
    
    func showEmptyLabel() {
        let emptyLabel: UILabel = UILabel(frame: CGRectMake(0, 0, tweetTableView.bounds.size.width, tweetTableView.bounds.size.height))
        
        emptyLabel.text = "Failed to twist"
        emptyLabel.textAlignment = .Center
        emptyLabel.sizeToFit()
        tweetTableView.backgroundView = emptyLabel
        tweetTableView.separatorStyle = .None
    }
    
    func onRefreshTweets() {
        //print("refresh")
        if isInitiatingData {
            return
        }
        
        refreshControl.beginRefreshing()
        
        tweetTableView.setContentOffset(CGPointMake(0, tweetTableView.contentOffset.y - refreshControl.frame.size.height), animated: true)
        
        onRefresh()
        
    }

}
