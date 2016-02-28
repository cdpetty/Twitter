//
//  TwitterClient.swift
//  TwitterCli
//
//  Created by Clayton Petty on 2/20/16.
//  Copyright © 2016 Clayton Petty. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "zPZoV0SCVGeFhL0DPMFejMeZA", consumerSecret: "uKVLeLmNLNIfwmBLokt3Jeq387IG9vdDfpDVB5otfwhWfWvUix")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    func login(success: ()->(), failure: (NSError)->()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token!")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error: NSError!) -> Void in
                self.loginFailure?(error)
        }    
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                print("Did this happen?")
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
        }) { (error: NSError!) -> Void in
            print("Error occurred getting access token")
            self.loginFailure?(error)
        }
 
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
                success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting tweets: \(error.localizedDescription)")
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //                        print("account: \(response)")
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            success(user)
            
            print("name: \(user.name)")
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting account")
                failure(error)
        })
    }
    
    func retweet(id: Int){
        POST("https://api.twitter.com/1.1/favorites/create.json?id=\(id)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("SuccesS!!!!!@!#!@#!@#!@# RETWEET")
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("darn")
        }
    }
    
    func favorite(id: Int){
        POST("https://api.twitter.com/1.1/statuses/retweet/\(id).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("SuccesS!!!!!@!#!@#!@#!@# FAVORITE")
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("darn")
        }       
    }
    
    func getUser(screenName: String, success: (NSDictionary) -> ()) {
        GET("https://api.twitter.com/1.1/users/show.json?screen_name=\(screenName)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as? NSDictionary
            
            success(userDictionary!)
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting clicked user")
        })
    }
    
    func tweety(tweet: String){
        let params: [String:String] = ["status": tweet]
        POST("https://api.twitter.com/1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("SuccesS!!!!!@!#!@#!@#!@# TWEETETETET")
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("bummer")
        }
    }
    func tweetRespond(tweet: String, id: Int){
        let params: [String:String] = ["status": tweet, "in_reply_to_status_id": "\(id)"]
        POST("https://api.twitter.com/1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("SuccesS!!!!!@!#!@#!@#!@# TWEETETETET")
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("bummer")
        }
    }
    
}
