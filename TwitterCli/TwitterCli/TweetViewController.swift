//
//  TweetViewController.swift
//  TwitterCli
//
//  Created by Clayton Petty on 2/27/16.
//  Copyright © 2016 Clayton Petty. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var replyTextBox: UITextView!
    @IBOutlet weak var rtButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    var tweet: Tweet!
    var time: NSString!
    
    func convertTimeToString(number: Int) -> String{
        let day = number / 86400
        let hour = (number - (day * 86400)) / 3600
        let minute = (number - (day * 86400) - (hour * 3600)) / 60
        
        if day != 0 {
            return "\(day)d"
        } else if hour != 0 {
            return "\(hour)h"
        } else{
            return "\(minute)m"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "@\(tweet.screenName!)"
        textLabel.text = tweet.text as? String
//        timeLabel.text = convertTimeToString(Int(NSDate().timeIntervalSinceDate(tweet.timestamp!)))
        rtButton.setTitle("RT: \(tweet.retweetCount)", forState: .Normal)
        favButton.setTitle("FAV: \(tweet.favoritesCount)", forState: .Normal)
        if tweet.profileImageUrl != nil {
            profileImage.setImageWithURL(tweet.profileImageUrl!)
        }
        
        print(tweet.id)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func retweetPressed(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet.id)
        rtButton.setTitle("RT: \(++tweet.retweetCount)", forState: .Normal)
    }
    
    @IBAction func favoritePressed(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite(tweet.id)
        favButton.setTitle("FAV: \(++tweet.favoritesCount)", forState: .Normal)
    }

    @IBAction func submitButton(sender: AnyObject) {
        TwitterClient.sharedInstance.tweetRespond(replyTextBox.text, id: tweet.id)
        replyTextBox.text = "SUBMITTED"
        
        
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
