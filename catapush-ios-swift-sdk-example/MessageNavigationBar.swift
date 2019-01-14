//
//  MessageNavigationBar.swift
//  catapush-ios-swift-sdk-example
//
//  Created by Chiarotto Alessandro on 11/12/15.
//  Copyright © 2015 Catapush s.r.l. All rights reserved.
//

import Foundation
import UIKit

class MessageNavigationBar : UINavigationBar {
    static var barTintColor = UIColor(red: 0, green: 144.0/255.0, blue: 213.0/255.0, alpha: 1)
    static var titleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 255.0/255.0, alpha: 1)]
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.barTintColor = MessageNavigationBar.barTintColor
        super.titleTextAttributes = MessageNavigationBar.titleTextAttributes
    }
    
}