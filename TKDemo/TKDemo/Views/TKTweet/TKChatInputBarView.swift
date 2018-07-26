//
//  TKChatInputBarView.swift
//  Teleglance
//
//  Created by Lam.Le on
//  Copyright © 2018 TK. All rights reserved.
//

import Foundation
import UIKit


protocol TKChatInputBarViewProtocol{
    func sendTweet(tweet:String);
    
    
}
let kHeightOfLine:Int = 40;
let kHeightOfChatBar:Int = 50;
let kMaximumLineText:Int = 5;
class TKChatInputBarView : UIView, UITextViewDelegate
{
    var delegate : TKChatInputBarViewProtocol?
    @IBOutlet var _inputTextView:UITextView!;
    @IBOutlet var _sendButton:UIButton!;
    @IBOutlet var _enterMessageLabel:UILabel!;
    @IBOutlet var _heightConstraint:NSLayoutConstraint!;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        

        _inputTextView.layer.borderColor = UIColor.white.cgColor;
        _inputTextView.layer.borderWidth = 1.0;
        _inputTextView.layer.cornerRadius = 5.0;
        _inputTextView.layer.masksToBounds = true;
        
        _enterMessageLabel.layer.borderColor = UIColor.white.cgColor;
        _enterMessageLabel.layer.borderWidth = 1.0;
        _enterMessageLabel.layer.cornerRadius = 5.0;
        _enterMessageLabel.layer.masksToBounds = true;
        
        _sendButton.isEnabled = false;
        
    }
    
    convenience init(delegate : TKChatInputBarViewProtocol){
        self.init()
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @IBAction func sendTweet(){
        self.delegate?.sendTweet(tweet: self._inputTextView.text);
    }
    
    func reset(){
        self._sendButton.isEnabled = false;
        self._inputTextView.text = "";
        self.textViewDidChange(self._inputTextView);
    }
    
    //MARK: Delegation - UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {

    }
    func textViewDidEndEditing(_ textView: UITextView) {
    }
    
    
    //Limit  text
    func textViewDidChange(_ textView: UITextView) {
        print(#function)
        let lineNumber = Int( textView.contentSize.height / (textView.font?.lineHeight)!) ;
        
        if lineNumber <= kMaximumLineText{
            self._heightConstraint.constant = CGFloat(kHeightOfChatBar + (lineNumber - 1) * Int(((textView.font?.lineHeight)!)));
        }
        
        self._sendButton.isEnabled = !(textView.text.isEmpty)
        
        if textView.text.isEmpty{
            self._enterMessageLabel.text = " Enter message";
            return;
        }
        self._enterMessageLabel.text = "";
        
    }
}

