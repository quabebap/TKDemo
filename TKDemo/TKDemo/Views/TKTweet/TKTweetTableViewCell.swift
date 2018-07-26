//
//  TKTweetTableViewCell.swift
//  TKDemo
//
//  Created by Lam Le on 7/26/18.
//  Copyright © 2018 TK. All rights reserved.
//

import UIKit
let kTweetBackgroundColor:UIColor = UIColor.init(red: 241.0/255.0, green: 241.0/255.0, blue: 243.0/255.0, alpha: 1.0)
let kTweetBackgroundColorHighlight:UIColor = UIColor.init(red: 0, green: 109.0/255.0, blue: 240.0/255.0, alpha: 1.0).withAlphaComponent(0.2)

class TKTweetTableViewCell: UITableViewCell {
    @IBOutlet var _title:UILabel!
    @IBOutlet var _subTitle:UILabel!
    @IBOutlet var _bgView:UIView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0;
        self.layer.masksToBounds = true;
        
        _subTitle.layer.cornerRadius = _subTitle.frame.size.width  / 2.0;
        _subTitle.layer.masksToBounds = true;
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithTweet(_ tweet:TKTweet, index:Int){
        if tweet.tweet_subs?.count == 0{
            _title.text = tweet.tweet_content
        }else{
            _title.text = tweet.tweet_subs![index] as? String
        }
        _subTitle.text = "\((_title.text?.count)!)"
        
        if let time = TimeInterval.init(tweet.tweet_id!){
            let now = NSDate().timeIntervalSince1970;
            print("time -> \(now - time)")
            // highligh color for tweet recent 20's
            if now - time < 20.0{
                self._bgView.backgroundColor = kTweetBackgroundColorHighlight;
            }else{
                self._bgView.backgroundColor = kTweetBackgroundColor;
            }
        }
    }

}
