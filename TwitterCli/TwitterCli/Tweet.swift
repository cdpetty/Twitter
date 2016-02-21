//
//  Tweet.swift
//  TwitterCli
//
//  Created by Clayton Petty on 2/20/16.
//  Copyright © 2016 Clayton Petty. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var screenName: NSString?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileImageUrl: NSURL?
    
    init(dictionary: NSDictionary) {
        // Get tweet text
        print(dictionary)
        text = dictionary["text"] as? String
        
        // Counts
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        print("FAV: \(favoritesCount), RT: \(retweetCount)")
        
        // Format date string
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
        // Screen name
        screenName = dictionary["user"]?["screen_name"] as? String
        print("NAMAMAMAMA: \(screenName)")
        
        // Profile pic
        let profileImageString = dictionary["user"]?["profile_image_url_https"] as? String
        if let profileImageString = profileImageString {
            profileImageUrl = NSURL(string: profileImageString)
        } else {
            profileImageUrl = nil
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }

}
