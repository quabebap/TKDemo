//
//  TKTweetVM.swift
//  TKDemo
//
//  Created by Lam Le on 7/25/18.
//  Copyright © 2018 TK. All rights reserved.
//

import Foundation
import CoreData
import UIKit
let kLimitCharactersTweet:Int = 50
let kNumberCharactersPrefix:Int = 4
class TKTweetVM: NSObject {
    static let sharedInstance:TKTweetVM = TKTweetVM();
    var _tweets:[TKTweet] = [TKTweet]();
    
    override init() {
        super.init();
    }
    
    func getAllTKTweets(_ completion:()->Void){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext;
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "TKTweet")
        let sort = NSSortDescriptor.init(key: "tweet_id", ascending: false)
        request.sortDescriptors = [sort];
        do{
            let results = try context.fetch(request)
            for tkTweet in results as! [TKTweet]{
                print("data -> \(tkTweet.tweet_content)");
                self._tweets.append(tkTweet);
            }
            
        }catch{
            assertionFailure("Failed fetch tweet")
        }
        completion();
    }
    
    func addTKTweet(_ tweet:String, subs:[String]){
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext;
        let tweetRecord:TKTweet = NSEntityDescription.insertNewObject(forEntityName: "TKTweet", into: context) as! TKTweet
        tweetRecord.tweet_id = "\(NSDate.init().timeIntervalSince1970)"
        tweetRecord.tweet_content = tweet
        tweetRecord.tweet_subs = NSArray.init(array: subs)
        
        do{
            let _ = try context.save()
            self._tweets.insert(tweetRecord, at: 0)
        }catch{
            assertionFailure("Add Tweet failure")
        }
    }
    
    func createTKTweet(_ tweet:String)->Bool{
        guard !tweet.isEmpty else {
            return false
        }
        
        var pieces = tweet.components(separatedBy: CharacterSet.whitespaces);
        // exist tweet 50 character without whitespace
        if pieces.contains(where: { (tweet) -> Bool in
            return tweet.count > kLimitCharactersTweet
        }){
            return false
        }
        
        // make tweet/subtweet
        var tktweets:[String] = [String]();
        var tweet:String = ""
        for item in pieces {
            if tweet == ""{
                tweet.append(item);
            }else{
                if tweet.count + item.count < kLimitCharactersTweet - kNumberCharactersPrefix{
                    tweet.append(" \(item)")
                }else{
                    tktweets.append(tweet);
                    tweet = "\(item)";
                }
            }
        }
        
        tktweets.append(tweet);
        
        if tktweets.count > 1{
            var index:Int = 0
            while index < tktweets.count{
                tktweets[index].insert(contentsOf: "\(index + 1)/\(tktweets.count) ", at: tktweets[index].startIndex);
                index = index + 1;
            }
        }
        
        self.addTKTweet(tweet, subs: tktweets);
        return true;
    }
}
