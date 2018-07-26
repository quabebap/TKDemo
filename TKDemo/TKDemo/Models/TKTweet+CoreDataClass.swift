//
//  TKTweet+CoreDataClass.swift
//  TKDemo
//
//  Created by Lam Le on 7/25/18.
//  Copyright © 2018 TK. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(TKTweet)
public class TKTweet: NSManagedObject {
    var heightOfTweets:[Int:CGFloat] = [Int:CGFloat]();
}
