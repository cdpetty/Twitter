//
//  ProfileViewController.swift
//  TwitterCli
//
//  Created by Clayton Petty on 2/27/16.
//  Copyright © 2016 Clayton Petty. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var screenName: NSString!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(screenName)
        TwitterClient.sharedInstance.getUser(screenName as String, success: { (dict: NSDictionary) -> () in
//            print("Asdf\(dict["friends_count"])")
            self.followersLabel.text =  "Followers: \(dict["followers_count"]!)"
            self.followingLabel.text = "Following: \(dict["friends_count"]!)"
            self.tweetsLabel.text = "Tweets: \(dict["listed_count"]!)"
            self.nameLabel.text = "@\(dict["screen_name"]!)"
            
            let profileImageUrl: NSURL!
            let profileImageString = dict["profile_image_url_https"] as? String
            if let profileImageString = profileImageString {
                profileImageUrl = NSURL(string: profileImageString)
            } else {
                profileImageUrl = nil
            }
            if profileImageUrl != nil {
                print("Setting image")
                self.profileImageView.setImageWithURL(profileImageUrl!)
            }
            
            self.title = "@\(dict["screen_name"]!)"
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
