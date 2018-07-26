//
//  TKTweetVC.swift
//  TKDemo
//
//  Created by Lam Le on 7/24/18.
//  Copyright © 2018 TK. All rights reserved.
//

import UIKit
import Foundation

let kHeightChatInputConstraint:String = "kHeightChatInputConstraint"
let kAlignBottomChatInputConstraint:String = "kAlignBottomChatInputConstraint"
let kTweetCellIdentifier:String = "kTweetCellIdentifier"
let kFontTweetTitle:UIFont = UIFont.systemFont(ofSize: 14.0)
let kHeightOfCellWithouTweet:CGFloat = 31.0
let kPaddingLeftAndRightTweet:CGFloat = 10.0

class TKTweetVC: UIViewController {
    @IBOutlet var _tweetTableView:UITableView!;
    @IBOutlet var _layoutConstraints:[NSLayoutConstraint]!;
    @IBOutlet var _chatInputBar:TKChatInputBarView!;
    
    var _tkTweetVM:TKTweetVM?;
    override func viewDidLoad() {
        super.viewDidLoad()
        _tkTweetVM = TKTweetVM.sharedInstance;
        _tkTweetVM?.getAllTKTweets {
            self._tweetTableView.reloadData();
        }
        
        self._chatInputBar.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidChangeFrame(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init();
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        tapGesture.addTarget(self, action: #selector(tap))
        self._tweetTableView.addGestureRecognizer(tapGesture);
    }

    @objc func tap(){
        self._chatInputBar._inputTextView.resignFirstResponder();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardDidChangeFrame(_ notification:Notification){
        if notification.userInfo == nil{
            return;
        }
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        
        if let cst =  self._layoutConstraints.first(where: { (constraint) -> Bool in
            return constraint.identifier == kAlignBottomChatInputConstraint
        }){
            cst.constant =  self.view.frame.size.height - keyboardFrame.origin.y - self.getSafeAreaInsets().bottom < 0 ? 0 : self.view.frame.size.height - keyboardFrame.origin.y - self.getSafeAreaInsets().bottom
        }
        
        
    }
    
    func getSafeAreaInsets()->UIEdgeInsets
    {
        if #available(iOS 11, *) {
            let window = UIApplication.shared.windows[0]
            let insets:UIEdgeInsets = window.safeAreaInsets
            return insets
        }
        else
        {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

}

extension TKTweetVC:UITableViewDelegate,UITableViewDataSource,UITableViewDataSourcePrefetching{
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self._tkTweetVM?._tweets.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self._tkTweetVM?._tweets[section].tweet_subs?.count == 0{
            return 1;
        }
        return (self._tkTweetVM?._tweets[section].tweet_subs?.count)!;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self._tkTweetVM?._tweets[indexPath.section].heightOfTweets[indexPath.row] == nil{
            if self._tkTweetVM?._tweets[indexPath.section].tweet_subs?.count == 0{
                self._tkTweetVM?._tweets[indexPath.section].heightOfTweets[indexPath.row] = (self._tkTweetVM?._tweets[indexPath.section].tweet_content?.height(withConstrainedWidth: (tableView.frame.size.width - kPaddingLeftAndRightTweet), font: kFontTweetTitle))! + kHeightOfCellWithouTweet
            }else{
                self._tkTweetVM?._tweets[indexPath.section].heightOfTweets[indexPath.row] = (self._tkTweetVM?._tweets[indexPath.section].tweet_subs?.object(at: indexPath.row) as! String).height(withConstrainedWidth: (tableView.frame.size.width - kPaddingLeftAndRightTweet), font: kFontTweetTitle) + kHeightOfCellWithouTweet
            }
            
        }
        return (self._tkTweetVM?._tweets[indexPath.section].heightOfTweets[indexPath.row])!;//self._tkTweetVM?._tweets[indexPath.section].heightOfTweet;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:TKTweetTableViewCell? = tableView.dequeueReusableCell(withIdentifier: kTweetCellIdentifier, for: indexPath) as? TKTweetTableViewCell
        if cell == nil{
            cell = TKTweetTableViewCell(style: .default, reuseIdentifier: kTweetCellIdentifier);
        }

        cell?.setupWithTweet( (self._tkTweetVM?._tweets[indexPath.section])!, index: indexPath.row);
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //  call before cellforRowAt indexpath
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2.5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.5
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = tableView.backgroundColor
    }
}

extension TKTweetVC:TKChatInputBarViewProtocol{
    func sendTweet(tweet: String) {
        if self._tkTweetVM?.createTKTweet(tweet) == true{
            // load to table
            self._tweetTableView.reloadData();
            self._tweetTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true);
            self._chatInputBar.reset();
            
        }else{
            // error
            let alertVC:UIAlertController = UIAlertController.init(title: "Error", message: "Tweet is invalid", preferredStyle: .alert);
            alertVC.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (ac   ) in
                alertVC.dismiss(animated: true, completion: {
                    
                });
            }));
            self.present(alertVC, animated: true, completion: nil);
        }
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

