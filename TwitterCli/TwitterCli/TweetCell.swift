//
//  TweetCell.swift
//  TwitterCli
//
//  Created by Clayton Petty on 2/20/16.
//  Copyright © 2016 Clayton Petty. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var formattedTime: NSString!
    
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
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.screenName as? String
            if tweet.profileImageUrl != nil {
                profileImage.setImageWithURL(tweet.profileImageUrl!)
            }
            
//            timestampLabel.text = "Friday"
            formattedTime = convertTimeToString(Int(NSDate().timeIntervalSinceDate(tweet.timestamp!)))
            timestampLabel.text = "\(formattedTime)"
            retweetButton.setTitle("RT: \(tweet.retweetCount)", forState: .Normal)
            favoriteButton.setTitle("FAV: \(tweet.favoritesCount)", forState: .Normal)
            bodyLabel.text = tweet.text! as String
            
            print("Stuff: \(tweet.screenName)")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
