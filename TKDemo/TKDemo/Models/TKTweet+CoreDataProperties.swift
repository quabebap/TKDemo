//
//  TKTweet+CoreDataProperties.swift
//  TKDemo
//
//  Created by Lam Le on 7/25/18.
//  Copyright © 2018 TK. All rights reserved.
//
//

import Foundation
import CoreData


extension TKTweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TKTweet> {
        return NSFetchRequest<TKTweet>(entityName: "TKTweet")
    }

    @NSManaged public var tweet_content: String?
    @NSManaged public var tweet_id: String?
    @NSManaged public var tweet_subs: NSArray?

}
