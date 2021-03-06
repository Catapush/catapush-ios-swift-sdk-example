//
//  MessageCollectionViewCell.swift
//  catapush-ios-swift-sdk-example
//
//  Created by Chiarotto Alessandro on 10/12/15.
//  Copyright © 2015 Catapush s.r.l. All rights reserved.
//

import Foundation
import UIKit

class MessageCollectionViewCell : UICollectionViewCell {

    static var textFont:UIFont = UIFont.systemFont(ofSize: 14)
    static var cornerRadius:CGFloat = 5
    static var borderWidth:CGFloat = 0.5
    static var borderColor:UIColor = UIColor(white: 0, alpha: 0.2)
    static var backgroundColor:UIColor = UIColor.white
    static var textColor = UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1)

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var topTimestampLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.backgroundColor = UIColor.clear.cgColor
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.messageTextView.layer.borderWidth = MessageCollectionViewCell.borderWidth
        self.messageTextView.layer.borderColor = MessageCollectionViewCell.borderColor.cgColor
        self.messageTextView.layer.cornerRadius = MessageCollectionViewCell.cornerRadius
        self.messageTextView.layer.masksToBounds = true
        self.messageTextView.layer.backgroundColor = MessageCollectionViewCell.backgroundColor.cgColor
        self.messageTextView.textColor = MessageCollectionViewCell.textColor
        self.messageTextView.font = MessageCollectionViewCell.textFont
    }
    
    static func sizeThatFits(_ size: CGSize,text:String,showTimestamp:Bool) -> CGSize {
        let messageTextView = UITextView()
        messageTextView.font = MessageCollectionViewCell.textFont
        messageTextView.text = text
        let s = messageTextView.sizeThatFits(size)
        if showTimestamp == true {
          return CGSize(width: s.width, height: s.height + 20)
        } else {
            return s
        }
    }
    
    func setTimestamp(_ date:Date)  {
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm"
        topTimestampLabel.text = dateFormatter.string(from: date)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.topTimestampLabel.text = nil
    }
}
