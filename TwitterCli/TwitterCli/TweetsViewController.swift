//
//  TweetsViewController.swift
//  TwitterCli
//
//  Created by Clayton Petty on 2/20/16.
//  Copyright © 2016 Clayton Petty. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
//                for tweet in tweets {
//                    print (tweet.text)
//                }
        
            }) { (error: NSError) -> () in
                print (error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
        
    }
    
    
    
    @IBAction func FavPressed(sender: AnyObject) {
        
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetCell
        cell.tweet.favoritesCount++
        button.setTitle("FAV: \(cell.tweet.favoritesCount)", forState: .Normal)
        TwitterClient.sharedInstance.favorite(cell.tweet.id)
    }
    
    @IBAction func retweetPressed(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetCell
        cell.tweet.retweetCount++
        button.setTitle("RT: \(cell.tweet.retweetCount)", forState: .Normal)
        TwitterClient.sharedInstance.retweet(cell.tweet.id)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (sender){
            case is UIButton:
                print("was a button")
                let button = sender as! UIButton
                let view = button.superview!
                let cell = view.superview as! TweetCell
                let indexPath = tableView.indexPathForCell(cell)
                
                let tweet = tweets[indexPath!.row]
                
                let profileViewController = segue.destinationViewController as! ProfileViewController
                profileViewController.screenName = tweet.screenName
                break
            
            case is UITableViewCell:
                print("was a table cell")
                let cell = sender as! TweetCell
                let indexPath = tableView.indexPathForCell(cell)
                
                let tweet = tweets[indexPath!.row]
                
                let tweetViewController = segue.destinationViewController as! TweetViewController
                tweetViewController.tweet = tweet
                tweetViewController.time = cell.formattedTime
                break
            default:
                print("uhoh")
        }
       
    }
    
    // MARK: - Navigation


}
