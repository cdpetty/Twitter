//
//  ComposeViewController.swift
//  TwitterCli
//
//  Created by Clayton Petty on 2/27/16.
//  Copyright © 2016 Clayton Petty. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    var screenName: NSString!
    
    @IBOutlet weak var tweetTextBox: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
                self.screenName = user.screenname
            self.nameLabel.text = "@\(self.screenName)"
            }) { (error: NSError) -> () in
                print("Error!")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.tweety(tweetTextBox.text)
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
